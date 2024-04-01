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
    @State private var selectedBarIndex: Int? = nil

    var body: some View {
        let safeMaxValue = max(maxValue, 1)
        let yAxisLabels = calculateYAxisLabels(from: safeMaxValue).reversed()

        HStack(alignment: .bottom) {
            VStack {
                ForEach(yAxisLabels, id: \.self) { label in
                    Text(label)
                        .font(.caption)
                        .padding(.bottom, 20)
                }
                Text(" Min")
                    .font(.caption)
            }
            .frame(height: 200)
            .padding(.trailing, 5)
            .padding(.bottom, 10)

            Rectangle()
                .frame(width: 1, height: 200)
                .foregroundColor(Color.gray)
                .padding(.bottom, 32)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(Array(zip(labels.indices, data)), id: \.0) { index, value in
                        VStack {
                            ZStack(alignment: .bottom) {
                                Capsule().frame(width: 20, height: 200)
                                    .foregroundColor(Color(.systemGray5))
                                VStack {
                                    Text("\(String(format: "%.1f", value))")
                                        .font(.caption)
                                        .frame(height: 20)
                                        .padding(.bottom, -5)
                                        .foregroundColor(Color.black.opacity(0.8))
                                    Capsule().frame(width: 20, height: value / safeMaxValue * 200)
                                        .foregroundColor(Color.green)
                                }
                            }
                            Text(labels[index])
                                .frame(width: 50)
                                .lineLimit(1)
                                .font(.caption)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 250)
        }
    }

    func calculateYAxisLabels(from maxValue: CGFloat) -> [String] {
        if maxValue <= 1 {
            return ["0", "0.2", "0.4", "0.6", "0.8", "1.0"]
        } else {
            let step = maxValue / 5
            return stride(from: 0, through: maxValue, by: step).map { String(format: "%.1f", $0) }
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BarChartView(
                data: Array(repeating: 5, count: 24),
                labels: (0..<24).map { String(format: "%02d:00", $0) },
                maxValue: 10
            )
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Day Selection")
        }
    }
}
