//
//  ProgressBarView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-27.
//

import SwiftUI

struct ProgressBarView: View {
    var counter: Int
    var countTo: Int

    var body: some View {
        GeometryReader { geometry in
            Circle()
                .trim(from: 0, to: progress())
                .stroke(Color.orange, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }

    func progress() -> CGFloat {
        return CGFloat(counter) / CGFloat(countTo)
    }
}

#Preview {
    ProgressBarView(counter: 75, countTo: 120)
        .previewLayout(.fixed(width: 250, height: 250))
        .padding()
}
