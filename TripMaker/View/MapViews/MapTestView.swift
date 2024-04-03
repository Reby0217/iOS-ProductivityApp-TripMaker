//
//  MapTestView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/28/24.
//

import SwiftUI
import SpriteKit

struct MapTestView: View {
    @Binding var presentSideMenu: Bool
    @State private var mapScene: MapScene? = nil
    
    @State var selectedRoute: String = "Taiwan"
    @State private var currentScale: CGFloat = 0.3
        
    var body: some View {
        ZStack {
            //Color(red: 0.7137255,green: 0.8627451, blue: 0.81176471).edgesIgnoringSafeArea(.all)
            

                
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
                
                
                
                NavigationSplitView {
                    ZStack {
                        //Color(red: 0.7137255,green: 0.8627451, blue: 0.81176471).edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            SpriteView(scene: mapScene ?? SKScene())
                                .ignoresSafeArea()
                                .frame(width: 400, height: 300) // Set the size of the map view
                                .gesture(MagnificationGesture().onChanged { scale in
                                    // Handle zooming in and out
                                    
                                    mapScene?.scaleBackground(scale: scale)
                                    
                                    currentScale = scale
                                })
                                .padding(.top, 30)
                                .padding(.bottom, 30)
                                //.background(Color(red: 0.7137255,green: 0.8627451, blue: 0.81176471).edgesIgnoringSafeArea(.all))
                            
                            Spacer()
                            
                            NavigationLink {
                                TimerRouteView(routeName: selectedRoute)
                            } label: {
                                Text("Start")
                                    .padding()
                                    .frame(width: 300)
                                    .background(Color.blue)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                } detail: {
                    
                }
                .frame(height: 600)
                
                Spacer()
            }
        }
        .onAppear {
            // Initialize the MapScene instance
            mapScene = MapScene(selectedRoute: $selectedRoute, currentScale: $currentScale)
        }
    }
}

#Preview {
    MapTestView(presentSideMenu: .constant(true))
}
