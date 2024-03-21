//
//  StatsView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/21/24.
//

import SwiftUI

struct StatsView: View {
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
            Text("Stats View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    StatsView(presentSideMenu: .constant(true))
}
