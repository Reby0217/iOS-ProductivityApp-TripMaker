//
//  ProfileView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-20.
//

import SwiftUI

struct ProfileView: View {
    @Binding var presentSideMenu: Bool
    
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

                    
                    VStack {
                        Image(dummyUserProfile.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .overlay(
                                RoundedRectangle(cornerRadius: 150)
                                    .stroke(.purple.opacity(0.7), lineWidth: 6)
                            )
                            .cornerRadius(150)
                            .padding(.top, 20)
                        Text(dummyUserProfile.username)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
                    
                    // Achievements section aligned left
                    Text("My Achievements")
                        .font(Font.custom("Noteworthy", size: 28))
                        .padding(.leading)

                    // Rewards list
                    ForEach(dummyRewards, id: \.rewardID) { reward in
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
                    .padding(.leading)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ProfileView(presentSideMenu: .constant(true))
}
