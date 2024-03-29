//
//  Scene.swift
//  TripMaker
//
//  Created by Megan Lin on 3/28/24.
//

import Foundation
import SwiftUI
import SpriteKit

struct SceneView: UIViewRepresentable {
    let scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.presentScene(scene)
        return skView
    }

    func updateUIView(_ uiView: SKView, context: Context) {}
}

class MapScene: SKScene {
    var initialScaleX: CGFloat!
    var initialScaleY: CGFloat!
    
    var background: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        // Add background image
        scene?.size = CGSize(width: 350, height: 300)
        print("init again")
        
        background = SKSpriteNode(imageNamed: "world_map.jpg")
        background.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        initialScaleX = size.width / background.size.width
        print(initialScaleX)
        initialScaleY = size.height / background.size.height
        print(initialScaleY)
        background.scale(to: self.size) // Scale the background to fit the scene
        background.zPosition = -1
        addChild(background)
        print("set background ", background)
    }
    
    func scaleBackground(newScale: CGFloat) {
        guard let background = self.background else {
            return
        }

        // Set the scale of the background node
        initialScaleX *= 1 - (1 - newScale) * 0.05
        initialScaleY *= 1 - (1 - newScale) * 0.05
        background.xScale = initialScaleX
        background.yScale = initialScaleY
        print("scale success ", self.background.xScale, self.background.yScale)
    }
}
