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
    @Environment(\.presentationMode) var presentationMode
    @State private var timeRemaining: TimeInterval
    @State private var cancelTimeRemaining: Int
    @State private var showCancelButton = true
    @State private var image: Image?
    @State private var timerSubscription: Cancellable?
    @State private var cancelTimerSubscription: Cancellable?

    init(routeName: String, totalTime: TimeInterval) {
        self.routeName = routeName
        self.totalTime = totalTime
        self._timeRemaining = State(initialValue: totalTime)
        self._cancelTimeRemaining = State(initialValue: totalTime <= 20 ? Int(totalTime/2) : 10)
    }

    var body: some View {
        VStack {
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
            
            if showCancelButton {
                Button("Cancel (\(cancelTimeRemaining)s)") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.lightGray)
                .foregroundColor(Color.gray)
                .cornerRadius(10)
            }
        }
        .onAppear {
            self.startTimer()
            self.startCancelTimer()
            self.loadImage()
        }
        .onDisappear {
            self.timerSubscription?.cancel()
            self.cancelTimerSubscription?.cancel()
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

    private func startCancelTimer() {
        self.cancelTimerSubscription = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
            if self.cancelTimeRemaining > 0 {
                self.cancelTimeRemaining -= 1
            } else {
                self.showCancelButton = false
                self.cancelTimerSubscription?.cancel()
            }
        }
    }
    
    private func loadImage() {
        DispatchQueue.main.async {
            let db = DBManager.shared
            do {
                let routeDetails = try db.fetchRouteDetails(route: routeName)
                self.image = Image(uiImage: UIImage(named: routeDetails.mapPicture) ?? UIImage())
            } catch {
                print("Timer View Database operation failed: \(error)")
            }
        }
    }
}

#Preview {
    TimerView(routeName: "Taiwan", totalTime: 5)
}
