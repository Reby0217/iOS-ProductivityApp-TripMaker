//
//  ProfileHeaderView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-20.
//

import SwiftUI

struct ProfileHeaderView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack {
                Spacer()
                Image("profilePic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.purple.opacity(0.7), lineWidth: 6)
                    )
                    .cornerRadius(50)
                    .padding(.top, 20)
                Spacer()
            }
            
            Text("Snow White")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            Text("ID: 1234567")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .frame(width: 250)
        .background(Color.white)
        .cornerRadius(10)
    }
}


#Preview {
    ProfileHeaderView()
}
