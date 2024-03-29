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
        
    var body: some View {
        SpriteView(scene: mapScene)
            .ignoresSafeArea()
            .frame(width: 350, height: 300) // Set the size of the game map view
            .gesture(MagnificationGesture().onChanged { scale in
                // Handle zooming in and out
                
                mapScene.scaleBackground(newScale: scale)
                print(scale)
            })
    }
}

#Preview {
    //MapTestView(scene: Scene(size: CGSize(width: 300, height: 400)))
    MapTestView(presentSideMenu: .constant(true))
}
