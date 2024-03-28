//
//  MapView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-20.
//

import SwiftUI

struct MapView: View {
    @Binding var showSideMenu: Bool
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var selectedSeconds = 0
    @State private var isTimePickerShown = false
    let lightGreen = Color(UIColor(red: 0, green: 0.8, blue: 0.3, alpha: 0.8))

    var body: some View {
        NavigationSplitView {
            VStack {
                HStack {
                    Button(action: {
                        self.showSideMenu.toggle()
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
                
                Image(uiImage: UIImage(named: "world_map.jpg")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .padding()
                
                Text("Set Focus Session Time")
                    .padding(.horizontal)
                    .font(Font.custom("Noteworthy", size: 26))
                    .padding(.bottom, -15)
                
                // Time display and toggle button
                HStack {
                    Spacer()
                    
                    Text("\(selectedHours)h \(selectedMinutes)m \(selectedSeconds)s")
                        .font(Font.custom("Noteworthy", size: 26))
                        .padding(.horizontal)

                    

                    Button(action: {
                        withAnimation {
                            self.isTimePickerShown.toggle()
                        }
                    }) {
                        Image(systemName: isTimePickerShown ? "chevron.down.circle" : "chevron.right.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding()
                            .tint(.green)
                    }
                }
                
                

                if isTimePickerShown {
                    TimePickerView(selectedHours: $selectedHours, selectedMinutes: $selectedMinutes, selectedSeconds: $selectedSeconds)
    //                    .transition(.slide)
                        .transition(.opacity)
                }
                
                Spacer()
                
                NavigationLink {
                    let totalTime = TimeInterval((selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds)
                    TimerView(routeName: "Taiwan", totalTime: totalTime)
                } label: {
                    Text("Start")
                        .padding()
                        .background(lightGreen)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                        .font(Font.custom("Papyrus", size: 25))
                }
                
                
                .padding(.bottom)
                
           
            }
            .padding(.horizontal, 24)
        } detail: {
            
        }
        
    }
}

#Preview {
    MapView(showSideMenu: .constant(true))
}
