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
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 24, height: 20)
                }
                Spacer()
            }
            
            Spacer()
            Text("Profile View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
#Preview {
    ProfileView(presentSideMenu: .constant(true))
}
