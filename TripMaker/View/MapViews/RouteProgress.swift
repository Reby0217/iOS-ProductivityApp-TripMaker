//
//  RouteProgress.swift
//  TripMaker
//
//  Created by Megan Lin on 3/31/24.
//

import SwiftUI

struct RouteProgress: View {
    @State private var routeCompletions: [CGFloat] = [0, 0.2, 0.5, 0.8, 1.0]
        
        var body: some View {
            ZStack {
                Color(hex: 0xc9dedb).edgesIgnoringSafeArea(.all)
                
                // Background image
                Image("taiwan-attractions-map")
                    .resizable()
                    .scaledToFit()
                
                // Curved progress bar
                GeometryReader { geometry in
                    Path { path in
                        // Define the path of the route
                        path.move(to: CGPoint(x: geometry.size.width - 70, y: geometry.size.height - 570)) // Start point
                        let controlPoint = CGPoint(x: geometry.size.width - 340, y: geometry.size.height - 360)
                        
                        path.addQuadCurve(to: CGPoint(x: geometry.size.width - 210, y: geometry.size.height - 160), control: controlPoint) // Curve
                                            
                    }
                    .stroke(Color.green, lineWidth: 10)
                }
                // Draw circles for each progress value
                ForEach(routeCompletions.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 15, height: 15)
                            .position(self.pointOnQuadraticBezier(startPoint: CGPoint(x: geometry.size.width - 70, y: geometry.size.height - 570),
                                controlPoint: CGPoint(x: geometry.size.width - 340, y: geometry.size.height - 360),
                                endPoint: CGPoint(x: geometry.size.width - 210, y: geometry.size.height - 160),
                                progress: Double(self.routeCompletions[index])))
                                }
                            }
            }
        }
    // Calculate a point along a quadratic Bézier curve
       private func pointOnQuadraticBezier(startPoint: CGPoint, controlPoint: CGPoint, endPoint: CGPoint, progress: Double) -> CGPoint {
           let t = CGFloat(progress)
           let oneMinusT = 1 - t
           
           // Bézier formula
           let x = oneMinusT * oneMinusT * startPoint.x + 2 * oneMinusT * t * controlPoint.x + t * t * endPoint.x
           let y = oneMinusT * oneMinusT * startPoint.y + 2 * oneMinusT * t * controlPoint.y + t * t * endPoint.y
           
           return CGPoint(x: x, y: y)
       }
}

#Preview {
    RouteProgress()
}
