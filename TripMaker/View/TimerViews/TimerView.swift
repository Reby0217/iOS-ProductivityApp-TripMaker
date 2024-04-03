//
//  TimerView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-27.
//

import SwiftUI
import Combine

struct TimerView: View {
    let dbManager = DBManager.shared
    
    var routeName: String
    var totalTime: TimeInterval
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @State private var timeRemaining: TimeInterval
    @State private var cancelTimeRemaining: Int
    @State private var showCancelButton = true
    @State private var image: Image?
    @State private var timerSubscription: Cancellable?
    @State private var cancelTimerSubscription: Cancellable?
    @State private var showBackButton = false
    
    @State private var focusSessionID: UUID?
    @State private var userID: UUID?

    init(routeName: String, totalTime: TimeInterval) {
        self.routeName = routeName
        self.totalTime = totalTime
        self._timeRemaining = State(initialValue: totalTime)
        self._cancelTimeRemaining = State(initialValue: totalTime <= 20 ? Int(totalTime/2) : 10)
    }

    var body: some View {
        VStack {
            RouteProgress(route: routeName, counter:  Int(totalTime - timeRemaining), countTo: Int(totalTime), startPos: 5)
                .frame(width: 400, height: 400)
                //.scaledToFit()
                //.padding()

            ZStack {
                ProgressTrackView()
                ProgressBarView(counter: Int(totalTime - timeRemaining), countTo: Int(totalTime))
                ClockView(timeRemaining: $timeRemaining)
            }
            .frame(width: 350, height: 350)
            .padding(.bottom, -50)
            
            if showCancelButton {
                Button("Cancel (\(cancelTimeRemaining)s)") {
//                    self.timerSubscription?.cancel()
//                    self.timeRemaining = totalTime
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.lightGray)
                .foregroundColor(Color.gray)
                .cornerRadius(10)
                .opacity(showCancelButton ? 1 : 0)
            }
            
            Spacer()
            
//            if showBackButton {
//                Button("Back to Map") {
//                    dismiss()
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(Color.white)
//                .cornerRadius(10)
//            }
        }
        .onAppear {
            fetchUserID()
            self.startTimer()
            self.startCancelTimer()
            self.loadImage()
        }
        .onDisappear {
            self.timerSubscription?.cancel()
            self.cancelTimerSubscription?.cancel()
        }
        .navigationBarBackButtonHidden(!showBackButton)
    }


    private func startTimer() {
        let newSessionID = UUID() // Create a new UUID for this focus session
        self.focusSessionID = newSessionID
        
        self.timerSubscription = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.showBackButton = true
                self.timerSubscription?.cancel()
                
                // The timer has finished, so save the focus session to the database
                if let userID = userID {
                    do {
                        let newSessionID = try self.dbManager.createFocusSession(
                            userID: userID,
                            startTime: Date().addingTimeInterval(-self.totalTime),
                            duration: self.totalTime
                        )
                        self.focusSessionID = newSessionID
                        self.showBackButton = true
                        print("Save focus session with ID \(newSessionID)")
                        
                        // Update user stats
                        do {
                            try dbManager.updateUserStats(userID: userID, focusTime: self.totalTime)
                        } catch {
                            print("Failed to update user stats: \(error)")
                        }
                        
                    } catch {
                        print("Failed to save focus session: \(error)")
                    }
                } else {
                    print("User ID is nil.")
                }
                
                
            }
        }
    }
    
    private func fetchUserID() {
        DispatchQueue.main.async {
            let username = "Snow White"
            do {
                if let userProfile = try dbManager.fetchUserProfileByUsername(username: username) {
                    self.userID = userProfile.userID
                }
            } catch {
                print("Failed to fetch user profile for '\(username)': \(error)")
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
            do {
                let routeDetails = try dbManager.fetchRouteDetails(route: routeName)
                self.image = imageFromString(routeDetails.mapPicture)
            } catch {
                print("Timer View Database operation failed: \(error)")
            }
        }
    }

}

#Preview {
    TimerView(routeName: "Taiwan", totalTime: 20)
}

