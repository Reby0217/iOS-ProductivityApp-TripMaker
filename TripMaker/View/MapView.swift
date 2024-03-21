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
            
            
            NavigationSplitView {
                Image(uiImage:UIImage(named: "world_map.jpg")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .padding()
                
                NavigationLink {
                    TimerView(routeName: "Taiwan")
                } label: {
                    Text("Start")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                }
            } detail: {
                
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
}

#Preview {
    MapView(presentSideMenu: .constant(true))
}
