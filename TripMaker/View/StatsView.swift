//
//  StatsView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-21
//

import SwiftUI

struct StatsView: View {
    @Binding var presentSideMenu: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Button(action: {
                    self.presentSideMenu.toggle()
                }) {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 24)
                }
                Spacer()
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("Focus Time")
                        .font(Font.custom("Noteworthy", size: 34))
                        .padding(.bottom, 10)
                    Spacer()
                    
                }
                HStack {
                    Spacer()
                    // Segment control for Day, Week, Year
                    Picker("Timeframe", selection: $timeframeSelection) {
                        Text("Day").tag(0)
                        Text("Week").tag(1)
                        Text("Year").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 250)
                    .padding()
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    BarChartView(data: getChartData(), labels: ["Mon", "Tue", "Wed", "Thu", "Fri"], maxValue: getMaxValue())
                        .frame(height: 200)
                        .padding(.top, 50)
                    Spacer()
                        
                }
            }
            Spacer()
        }
    }
    
    @State private var timeframeSelection: Int = 0

    // dummy data
    func getChartData() -> [CGFloat] {
        switch timeframeSelection {
        case 0: // Day
            return [5, 8, 3, 6, 1]
        case 1: // Week
            return [8, 5, 7, 6, 8]
        case 2: // Year
            return [200, 250, 225, 275, 300]
        default:
            return []
        }
    }
    
    // Get the maximum value for setting the chart scale
    func getMaxValue() -> CGFloat {
        switch timeframeSelection {
        case 0:
            return 10
        case 1: // Week
            return 10
        case 2: // Year
            return 400
        default:
            return 10
        }
    }
}

#Preview {
    StatsView(presentSideMenu: .constant(true))
}
