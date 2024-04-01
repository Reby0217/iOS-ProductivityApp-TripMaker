//
//  StatsView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-21
//

import SwiftUI

struct StatsView: View {
    @Binding var presentSideMenu: Bool
    @State private var timeframeSelection: Int = 0

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
                    BarChartView(data: getChartData(), labels: getLabels(), maxValue: getMaxValue())
                        .frame(height: 200)
                        .padding(.top, 50)
                    Spacer()
                }
            }
            Spacer()
        }
    }

    func getChartData() -> [CGFloat] {
        switch timeframeSelection {
        case 0: // Day
            return [5, 8, 3, 6, 1,3,5,7,7,1,8,4,0,0,0,0,2,4,0,0,0,0,0,0]
        case 1: // Week
            return [8, 5, 7, 6, 8, 1, 5, 10]
        case 2: // Year
            return [200, 250, 225, 275, 300, 232, 155, 222, 111, 332, 241, 88]
        default:
            return []
        }
    }

    func getMaxValue() -> CGFloat {
        let data = getChartData()
        return data.max() ?? 10
    }
    
    func getLabels() -> [String] {
        switch timeframeSelection {
        case 0:
            return (0..<24).map { String(format: "%02d:00", $0) }
        case 1:
            return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        case 2:
            return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        default:
            return []
        }
    }
}

#Preview {
    StatsView(presentSideMenu: .constant(true))
}
