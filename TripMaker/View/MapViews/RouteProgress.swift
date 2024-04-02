//
//  RouteProgress.swift
//  TripMaker
//
//  Created by Megan Lin on 3/31/24.
//

import SwiftUI

struct RouteProgress: View {
    @State var route: String
    let routeCompletions: [Double] = [0, 0.15, 0.4, 0.65, 0.85, 1.0]
    @State var currentProgress: Double = 0
    @State var width: CGFloat = 400
    @State var height: CGFloat = 400
    
    var startPoint: CGPoint {CGPoint(x: width - 70, y: height - 440)}
    var endPoint: CGPoint {CGPoint(x: width - 215, y: height - 50)}
    var controlPoint: CGPoint {calculateControlPoint(start: startPoint, end: endPoint, factor: 200)}
    var attractions: [CGPoint] {
        route_attractions[route]!
    }
    var segments: [Int: [[String: CGPoint]]] {
        route_segments[route]!
    }
    
        
    var body: some View {
        ZStack {
            Color(hex: 0xc9dedb).edgesIgnoringSafeArea(.all)
            
            // Background image
            Image(route + "-route")
                .resizable()
                .frame(width: width, height: height)
                .scaledToFit()
                
            // Curved progress bar
            /*
            GeometryReader { geometry in
                
                Path { path in
                    // Define the path of the route
                    path.move(to: startPoint) // Start point
    
                    path.addQuadCurve(to: endPoint, control: controlPoint) // Curve
                                            
                }
                .stroke(Color.gray.opacity(0.8), lineWidth: 10)
                
            }
            .frame(width: width, height: height)
             */
            
            var currentPoint = CGPoint(x: 0, y: 0)
            //var point_ = CGPoint(x: 0, y: 0)
            
            ForEach(segments.keys.sorted(), id: \.self){ key in
                ForEach(segments[key]!, id: \.self){ node in
                    GeometryReader { geometry in
                        
                        Path { path in
                            path.move(to: (node["startPoint"])!) // Start point
                            
                            path.addQuadCurve(to: (node["endPoint"])!, control: (node["controlPoint"])!) // Curve
                        }
                        .stroke(Color.purple, lineWidth: 8)
                    }
                    .frame(width: width, height: height)
                }
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
            
            let pos = pointOnQuadraticBezier(startPoint: startPoint,
                 controlPoint: controlPoint,
                 endPoint: endPoint,
                progress: currentProgress)
            /*
            LottieView(animationFileName: "WalkingAnimation", loopMode: .loop)
                .scaleEffect(0.1)
                .position(x: attractions[3].x, y: attractions[3].y)
                .frame(width: width, height: height)
             */
                    
        }
    }
    
    func calculateControlPoint(start: CGPoint, end: CGPoint, factor: CGFloat) -> CGPoint {
        // Calculate midpoint
        let midpoint = CGPoint(x: (start.x + end.x) / 2, y: (start.y + end.y) / 2)
        
        // Calculate adjustment vector (perpendicular to the line connecting start and end points)
        let dx = end.x - start.x
        let dy = end.y - start.y
        let adjustmentVector = CGPoint(x: -dy, y: dx)
        
        // Normalize adjustment vector
        let magnitude = sqrt(adjustmentVector.x * adjustmentVector.x + adjustmentVector.y * adjustmentVector.y)
        let normalizedAdjustmentVector = CGPoint(x: adjustmentVector.x / magnitude, y: adjustmentVector.y / magnitude)
        
        // Scale and adjust the midpoint by the factor
        let controlPoint = CGPoint(x: midpoint.x + normalizedAdjustmentVector.x * factor, y: midpoint.y + normalizedAdjustmentVector.y * factor)
        
        return controlPoint
    }
    
    // Calculate a point along a quadratic Bézier curve
    func pointOnQuadraticBezier(startPoint: CGPoint, controlPoint: CGPoint, endPoint: CGPoint, progress: Double) -> CGPoint {
        let t = CGFloat(progress)
        let oneMinusT = 1 - t
        
        // Bézier formula
        let x = oneMinusT * oneMinusT * startPoint.x + 2 * oneMinusT * t * controlPoint.x + t * t * endPoint.x
        let y = oneMinusT * oneMinusT * startPoint.y + 2 * oneMinusT * t * controlPoint.y + t * t * endPoint.y
           
        return CGPoint(x: x, y: y)
    }
}

#Preview {
    RouteProgress(route: "Taiwan", currentProgress: 0.5)
}
