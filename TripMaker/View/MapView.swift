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
