//
//  BarChartView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-21.
//

import SwiftUI

struct BarChartView: View {
    var data: [CGFloat]
    var labels: [String]
    var maxValue: CGFloat
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(0..<data.count, id: \.self) { index in
                VStack {
                    ZStack(alignment: .bottom) {
                        Capsule().frame(width: 20, height: 200)
                            .foregroundColor(Color(.systemGray5))
                        Capsule().frame(width: 20, height: data[index] / maxValue * 200)
                            .foregroundColor(Color.blue)
                    }
                    Text(labels[index])
                }
            }
        }
    }
}

#Preview {
    BarChartView(
        data: [3, 5, 7, 6, 8],
        labels: ["Mon", "Tue", "Wed", "Thu", "Fri"],
        maxValue: 10
    )
    .frame(height: 200)
    .padding()
    .previewLayout(.sizeThatFits)
}
