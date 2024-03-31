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
        SpriteView(scene: mapScene)
            .ignoresSafeArea()
            .frame(width: 380, height: 300) // Set the size of the map view
            .gesture(MagnificationGesture().onChanged { scale in
                // Handle zooming in and out
                // Set the scale of the background node
                
                let scaleFactor = mapScene.background.xScale + (scale - mapScene.background.xScale) * 0.5
                
                
                print(scaleFactor)
                //let minScale = min(scaleX, scaleY)
                //background.setScale(minScale)
                 
            
                let scale = max(min(scaleFactor, 1.0), 0.26)
                mapScene.scaleBackground(newScale: scale)
                print("applied scale: ", scale)
                
                currentScale = scale
            })
    }
}

#Preview {
    //MapTestView(scene: Scene(size: CGSize(width: 300, height: 400)))
    MapTestView(presentSideMenu: .constant(true))
}
