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
    @State private var isNavigatingToTimer = false
    let lightGreen = Color(UIColor(red: 0, green: 0.8, blue: 0.35, alpha: 0.8))

    var body: some View {
        NavigationStack {
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

                .padding()
                
                if isTimePickerShown {
                    TimePickerView(selectedHours: $selectedHours, selectedMinutes: $selectedMinutes, selectedSeconds: $selectedSeconds)
                        .transition(.opacity)
                }
                
                Spacer()
                
                Button("Start") {
                    isNavigatingToTimer = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.bottom)
                .tint(lightGreen)
            }
            .navigationDestination(isPresented: $isNavigatingToTimer) {
                TimerView(
                    routeName: "Taiwan",
                    totalTime: TimeInterval((selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds)
                )
            }
        }
    }
}

#Preview {
    MapView(showSideMenu: .constant(true))
}
