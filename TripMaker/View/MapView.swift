//
//  MapView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-20.
//

import SwiftUI

struct MapView: View {
    @Binding var presentSideMenu: Bool
    
    var body: some View {
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
            
            Spacer()
            Text("Map View")
            
            NavigationView {
                NavigationLink {
                    TimerView(routeName: "Taiwan")
                } label: {
                    Text("Start")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    MapView(presentSideMenu: .constant(true))
}
