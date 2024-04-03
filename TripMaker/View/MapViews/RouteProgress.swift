//
//  RouteProgress.swift
//  TripMaker
//
//  Created by Megan Lin on 3/31/24.
//

import SwiftUI

struct RouteProgress: View {
    @State var route: String
    @State var routeDetail: Route?

    @State var currentProgress: Double = 0
    @State var startPos: Int = 0
    var curPos: CGPoint {
        pointOnQuadraticBezier(startPoint: segments[startPos+1]!["startPoint"]!, controlPoint: segments[startPos+1]!["controlPoint"]!, endPoint: segments[startPos+1]!["endPoint"]!, progress: currentProgress)
    }
    
    @State var width: CGFloat = 400
    @State var height: CGFloat = 400
    
    var attractions: [CGPoint] {
        route_attractions[route]!
    }
    var segments: [Int: [String: CGPoint]] {
        route_segments[route]!
    }
    
        
    var body: some View {
        ZStack {
            Color(hex: 0xc9dedb).edgesIgnoringSafeArea(.all)
            
            // Background image
            //Image(route+"-route")
            imageFromString(routeDetail?.mapPicture ?? "")?
                .resizable()
                .frame(width: width, height: height)
                .scaledToFit()
            
                
            // Previous Progress
            ForEach(0..<Int(startPos+1)){ key in
                GeometryReader { geometry in
                        
                    Path { path in
                        path.move(to: (segments[key]!["startPoint"])!) // Start point
                            
                        path.addQuadCurve(to: (segments[key]!["endPoint"])!, control: (segments[key]!["controlPoint"])!) // Curve
                    }
                    .stroke(Color.purple.opacity(0.7), lineWidth: 10)
                }
                .frame(width: width, height: height)
            }
             
            
            // Current progress bar
            var tmp = CGPoint(x: 0, y: 0)
            
            ForEach(0..<Int(currentProgress*100+1)){ index in
                GeometryReader { geometry in
                    
                    Path { path in
                        // Define the path of the route
                        
                        let cur = pointOnQuadraticBezier(startPoint: segments[startPos+1]!["startPoint"]!, controlPoint: segments[startPos+1]!["controlPoint"]!, endPoint: segments[startPos+1]!["endPoint"]!, progress: Double(index)/100)
                        
                        if index != 0 && index != Int(currentProgress*100) {
                            
                            let controlPoint = calculateControlPoint(start: tmp, end: cur, factor: 0)
                            
                            path.move(to: tmp) // Start point
                            
                            path.addQuadCurve(to: cur, control: controlPoint) // Curve
                            
                        }
                        tmp = cur
                                                
                    }
                    .stroke(Color.purple.opacity(0.7), lineWidth: 10)
                    
                }
                .frame(width: width, height: height)
             }
            
            
            // Draw circles for each progress value
            ForEach(attractions.indices, id: \.self) { index in
                GeometryReader { geometry in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 15, height: 15)
                        .position(self.attractions[index])
                }
                .frame(width: width, height: height)
            }
            
            
            LottieView(animationFileName: "WalkingAnimation", loopMode: .loop, flip: false)
                .scaleEffect(0.05)
                .position(x: curPos.x, y: curPos.y - 30)
                .frame(width: width, height: height)
             
                    
        }
        .onAppear {
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    self.routeDetail = try db.fetchRouteDetails(route: route)
                } catch {
                    print("Location Row View Database operation failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    RouteProgress(route: "Taiwan", currentProgress: 0.7, startPos: 5)
}
