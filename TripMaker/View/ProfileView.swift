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

            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        self.presentSideMenu.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 20)
                    }
                    Spacer()
                }
                .padding(.horizontal)

          
                
                // User picture and name
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
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 20)

                Text("My Achievements")
                    .font(.headline)
                    .padding(.bottom, 10)

                // Rewards List
                ForEach(dummyRewards, id: \.rewardID) { reward in
                    VStack {
                        imageFromString(reward.picture)? // Use actual image fetching logic
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .padding()
                        Text(reward.name) // Replace with actual reward name
                            .font(.caption)
                    }
                }

                Spacer()
            }
        }
    }
}

#Preview {
    ProfileView(presentSideMenu: .constant(true))
}
