//
//  RouteProgress.swift
//  TripMaker
//
//  Created by Megan Lin on 3/31/24.
//

import SwiftUI

struct RouteProgress: View {
    let routeCompletions: [Double] = [0, 0.15, 0.4, 0.65, 0.85, 1.0]
    @State var currentProgress: Double = 0
    
        
    var body: some View {
        ZStack {
            Color(hex: 0xc9dedb).edgesIgnoringSafeArea(.all)
            
            // Background image
            Image("taiwan-attractions-map")
                .resizable()
                .frame(width: 400, height: 500)
                .scaledToFit()
                
            // Curved progress bar
            GeometryReader { geometry in
                let startPoint = CGPoint(x: geometry.size.width - 70, y: geometry.size.height - 440)
                let endPoint = CGPoint(x: geometry.size.width - 215, y: geometry.size.height - 50)
                let controlPoint = calculateControlPoint(start: startPoint, end: endPoint, factor: 200)
                
                Path { path in
                    // Define the path of the route
                    path.move(to: startPoint) // Start point
    
                    path.addQuadCurve(to: endPoint, control: controlPoint) // Curve
                                            
                }
                .stroke(Color.gray.opacity(0.8), lineWidth: 10)
                
            }
            .frame(width: 400, height: 500)
            
            var currentPoint = CGPoint(x: 330, y: 185)
            ForEach(0..<Int(currentProgress*1000 + 1)){ index in
                GeometryReader { geometry in

                    let startPoint = CGPoint(x: geometry.size.width - 70, y: geometry.size.height - 440)
                    let endPoint = CGPoint(x: geometry.size.width - 215, y: geometry.size.height - 50)
                    let controlPoint = calculateControlPoint(start: startPoint, end: endPoint, factor: 200)
                    
                    
                    Path { path in
                        // Define the path of the route
                        let newEndPoint = pointOnQuadraticBezier(startPoint: startPoint,
                            controlPoint: controlPoint,
                            endPoint: endPoint,
                            progress: Double(index)/1000)
                        
                        if index == 0 || index == Int(currentProgress*1000) {
                            currentPoint = newEndPoint
                        } else {
                            
                            
                            let newControlPoint = calculateControlPoint(start: currentPoint, end: newEndPoint, factor: 1)
                            path.move(to: currentPoint) // Start point
                            
                            path.addQuadCurve(to: newEndPoint, control: newControlPoint) // Curve
                            
                            currentPoint = newEndPoint
                        }
                    }
                    .stroke(Color.purple, lineWidth: 8)
                }
                .frame(width: 400, height: 500)
            }
            
            
            // Draw circles for each progress value
            ForEach(routeCompletions.indices, id: \.self) { index in
                GeometryReader { geometry in
                    let startPoint = CGPoint(x: geometry.size.width - 70, y: geometry.size.height - 440)
                    let endPoint = CGPoint(x: geometry.size.width - 215, y: geometry.size.height - 50)
                    let controlPoint = calculateControlPoint(start: startPoint, end: endPoint, factor: 200)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 15, height: 15)
                        .position(self.pointOnQuadraticBezier(startPoint: startPoint,
                            controlPoint: controlPoint,
                            endPoint: endPoint,
                            progress: self.routeCompletions[index]))
                }
                .frame(width: 400, height: 500)
            }
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
    RouteProgress(currentProgress: 0.5)
}
