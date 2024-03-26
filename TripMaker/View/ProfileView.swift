//
//  ProfileView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-20.
//

import SwiftUI

struct ProfileView: View {
    @Binding var presentSideMenu: Bool
    @State private var userProfile: UserProfile?
    @State private var userRewards: [Reward] = []

    let dbManager = DBManager.shared

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3), Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
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
                    
                    if let userProfile = userProfile {
                        VStack {
                            imageFromString(userProfile.image)?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 150)
                                        .stroke(.purple.opacity(0.7), lineWidth: 6)
                                )
                                .cornerRadius(150)
                                .padding(.top, 20)
                            Text(userProfile.username)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 20)
                    } else {
                        Text("Loading profile...")
                            .font(.title)
                    }
                    
                    // Achievements section
                    Text("My Achievements")
                        .font(Font.custom("Noteworthy", size: 28))
                        .padding(.leading)
                    
                    ForEach(userRewards.chunked(into: 3), id: \.self) { rowRewards in
                        HStack {
                            ForEach(rowRewards, id: \.name) { reward in
                                VStack {
                                    imageFromString(reward.picture)?
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 150)
                                                .stroke(.purple.opacity(0.5), lineWidth: 6)
                                        )
                                        .cornerRadius(150)
                                        .padding(.top, 20)
                                        .padding(.bottom, 1)
                                    Text(reward.name)
                                        .font(Font.custom("Optima", size: 14))
                                }
                            }
                        }
                    }
                    
                    .padding(.leading)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            fetchUserProfile()
        }
    }
    
    private func fetchUserProfile() {
        do {
            if let fetchedUserProfile = try dbManager.fetchUserProfileByUsername(username: "Snow White") {
                self.userProfile = fetchedUserProfile
                self.userRewards = fetchedUserProfile.rewardsArray.compactMap { rewardName in
                    do {
                        return try dbManager.fetchRewardDetails(name: rewardName)
                    } catch {
                        print("Error fetching reward details for \(rewardName): \(error)")
                        return nil
                    }
                }
            } else {
                print("User profile not found.")
            }
        } catch {
            print("Error fetching user profile: \(error)")
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


#Preview {
    ProfileView(presentSideMenu: .constant(true))
}
