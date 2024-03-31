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
    
    //var scene: SKScene
    var mapScene = MapScene()
    @State private var currentScale: CGFloat = 0.26
        
    var body: some View {
        ZStack {
            Color(red: 0.7137255,green: 0.8627451, blue: 0.81176471).edgesIgnoringSafeArea(.all)
            

                
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
                        Color(red: 0.7137255,green: 0.8627451, blue: 0.81176471).edgesIgnoringSafeArea(.all)
                        
                        SpriteView(scene: mapScene)
                            .ignoresSafeArea()
                            .frame(width: 390, height: 310) // Set the size of the map view
                            .gesture(MagnificationGesture().onChanged { scale in
                                // Handle zooming in and out
                                // Set the scale of the background node
                                
                                let scaleFactor = mapScene.background.xScale + (scale - mapScene.background.xScale) * 0.5
                                
                                print(scaleFactor)
                                //let minScale = min(scaleX, scaleY)
                                //background.setScale(minScale)
                                
                                
                                let scale = max(min(scaleFactor, 1.0), 0.3)
                                mapScene.scaleBackground(newScale: scale)
                                print("applied scale: ", scale)
                                
                                currentScale = scale
                            })
                            .background(Color.clear)
                        //.padding(.vertical, 15)
                        
                    }
                } detail: {
                    
                }
                .frame(height: 400)
                .popover(isPresented: .constant(true), attachmentAnchor: .point(UnitPoint(x: 300,y: 200)), arrowEdge: Edge.leading){
                    RoutePopover(route: "Taiwan")
                        .frame(width: 300, height: 400)
                        .presentationCompactAdaptation(.none)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    //MapTestView(scene: Scene(size: CGSize(width: 300, height: 400)))
    MapTestView(presentSideMenu: .constant(true))
}
