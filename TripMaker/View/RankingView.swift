//
//  RankingView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/21/24.
//

import SwiftUI

struct RankingView: View {
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 28, height: 24)
                }
                Spacer()
            }
            
            Spacer()
            Text("Ranking View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    RankingView(presentSideMenu: .constant(true))
}
