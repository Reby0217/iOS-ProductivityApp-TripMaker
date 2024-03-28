//
//  TimerView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-27.
//

import SwiftUI
import Combine

struct TimerView: View {
    var routeName: String
    var totalTime: TimeInterval
    @State private var timeRemaining: TimeInterval
    @State private var image: Image?
    @State private var timerSubscription: Cancellable?

    init(routeName: String, totalTime: TimeInterval) {
        self.routeName = routeName
        self.totalTime = totalTime
        self._timeRemaining = State(initialValue: totalTime)
    }

    var body: some View {
        VStack {
            Spacer()
            image?
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding()
            ZStack {
                ProgressTrackView()
                ProgressBarView(counter: Int(totalTime - timeRemaining), countTo: Int(totalTime))
                ClockView(timeRemaining: $timeRemaining)
            }
            .frame(width: 350, height: 350)
            Spacer()
        }
        .onAppear {
            self.startTimer()
            DispatchQueue.main.async {
                self.startTimer()
                let db = DBManager.shared
                do {
                    let routeDetails = try db.fetchRouteDetails(route: routeName)
                    self.image = imageFromString(routeDetails.mapPicture)
                } catch {
                    print("Timer View Database operation failed: \(error)")
                }
            }
        }
        .onDisappear {
            self.timerSubscription?.cancel()
        }
    }

    private func startTimer() {
        self.timerSubscription = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timerSubscription?.cancel()
            }
        }
    }
}

#Preview {
    TimerView(routeName: "Taiwan", totalTime: 730)
}
