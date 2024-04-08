//
//  ProfileView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-20.
//

import SwiftUI

struct ProfileView: View {
    @Binding var presentSideMenu: Bool
    @State private var editableUsername: String = Constants.userName
    @State private var isEditing: Bool = false
    
    private var userProfile: UserProfile? {
        Constants.userProfile
    }
    
    private var userRewards: [Reward] {
        userProfile?.rewardsArray.compactMap { rewardName in
            do {
                return try DBManager.shared.fetchRewardDetails(name: rewardName)
            } catch {
                print("Error fetching reward details for \(rewardName): \(error)")
                return nil
            }
        }.sorted(by: { $0.name < $1.name }) ?? []
    }

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
                    
                    // Display the user profile information
                    if let userProfile = userProfile {
                        VStack {
                            imageFromString(userProfile.image)?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .cornerRadius(75)
                                .overlay(Circle().stroke(Color.purple.opacity(0.7), lineWidth: 4))
                                .padding(.top, 20)
                            
                            // Username field editable
                            if isEditing {
                                TextField("Username", text: $editableUsername)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                Button("Save") {
                                    saveUsername()
                                }
                            } else {
                                Text(userProfile.username)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Button("Edit") {
                                    self.isEditing = true
                                }
                            }
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
                                        .frame(width: 100)
                                }
                            }
                        }
                        .padding(.vertical, -10)
                        
                    }
                    
                    .padding(.leading)
                }
                .padding(.horizontal)
            }
        }
//        .onAppear {
//            fetchUserProfile()
//        }
    }
    
//    private func fetchUserProfile() {
//        do {
//            if let fetchedUserProfile = try dbManager.fetchUserProfileByUsername(username: Constants.userName) {
//                self.userProfile = fetchedUserProfile
//                self.userRewards = fetchedUserProfile.rewardsArray.compactMap { rewardName in
//                    do {
//                        return try dbManager.fetchRewardDetails(name: rewardName)
//                    } catch {
//                        print("Error fetching reward details for \(rewardName): \(error)")
//                        return nil
//                    }
//                }.sorted(by: { $0.name < $1.name })
//            } else {
//                print("User profile not found.")
//            }
//        } catch {
//            print("Error fetching user profile: \(error)")
//        }
//    }
    
    private func saveUsername() {
        guard let userID = Constants.userID, !editableUsername.isEmpty else { return }
        
        DBManager.shared.isUsernameUnique(editableUsername) { isUnique in
            if isUnique {
                do {
                    try DBManager.shared.updateUsername(userID: userID, newUsername: self.editableUsername)
                    // Reflect changes immediately
                    self.isEditing = false
                    Constants.userName = self.editableUsername // trigger the "refresh" of userProfile due to the computed property in Constants
                } catch {
                    print("Error updating username: \(error)")
                }
            } else {
                print("Username is not unique.")
            }
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
