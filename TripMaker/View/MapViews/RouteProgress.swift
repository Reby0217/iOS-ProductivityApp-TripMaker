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
    @State var width: CGFloat = 400
    @State var height: CGFloat = 400
    
    var startPoint: CGPoint {CGPoint(x: width - 70, y: height - 440)}
    var endPoint: CGPoint {CGPoint(x: width - 215, y: height - 50)}
    var controlPoint: CGPoint {calculateControlPoint(start: startPoint, end: endPoint, factor: 200)}
    var attractions: [CGPoint] {
        [CGPoint(x: width - 50,y: height - 300),
         CGPoint(x: width - 150,y: height - 300),
         CGPoint(x: width - 278,y: height - 240),
         CGPoint(x: width - 324,y: height - 150),
         CGPoint(x: width - 230,y: height - 94),
         CGPoint(x: width - 212,y: height - 200),
         CGPoint(x: width - 130,y: height - 165),
         CGPoint(x: width - 125,y: height - 94),
         CGPoint(x: width - 125,y: height - 30)]
    }
    var segments: [Int: [String: CGPoint]] {
        [1 : ["startPoint": attractions[8], "endPoint": attractions[7], "controlPoint": attractions[8]],
         2 : ["startPoint": attractions[7], "endPoint": attractions[4], "controlPoint": attractions[7]],
         3 : ["startPoint": attractions[4], "endPoint": CGPoint(x: width - 319, y: height - 100), "controlPoint": CGPoint(x: width - 318, y: height - 90)],
         4 : ["startPoint": CGPoint(x: width - 317, y: height - 97), "endPoint": attractions[3], "controlPoint": CGPoint(x: width - 327, y: height - 108)],
        ]
    }
    
        
    var body: some View {
        ZStack {
            Color(hex: 0xc9dedb).edgesIgnoringSafeArea(.all)
            
            // Background image
            Image("taiwan-route")
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
                GeometryReader { geometry in
                    
                    Path { path in
                        path.move(to: (segments[key]?["startPoint"])!) // Start point
        
                        path.addQuadCurve(to: (segments[key]?["endPoint"])!, control: (segments[key]?["controlPoint"])!) // Curve
                    }
                    .stroke(Color.purple, lineWidth: 8)
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
            
            let pos = pointOnQuadraticBezier(startPoint: startPoint,
                 controlPoint: controlPoint,
                 endPoint: endPoint,
                progress: currentProgress)
            LottieView(animationFileName: "WalkingAnimation", loopMode: .loop)
                .scaleEffect(0.1)
                .position(x: attractions[3].x, y: attractions[3].y - 50)
                .frame(width: width, height: height)
                    
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
