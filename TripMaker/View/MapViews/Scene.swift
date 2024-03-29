//
//  Scene.swift
//  TripMaker
//
//  Created by Megan Lin on 3/28/24.
//

import Foundation
import SwiftUI
import SpriteKit


class MapScene: SKScene {
    var initialScaleX: CGFloat!
    var initialScaleY: CGFloat!
    var lastTouchPosition: CGPoint? // Store the last touch position
    
    var background: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        // Add background image
        scene?.size = CGSize(width: 350, height: 300)
        print("init again")
        
        background = SKSpriteNode(imageNamed: "world_map.jpg")
        background.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        background.scale(to: self.size) // Scale the background to fit the scene
        initialScaleX = background.xScale
        initialScaleY = background.yScale
        background.zPosition = -1
        addChild(background)
        //print("set background ", background)
        isUserInteractionEnabled = true
        
        // Add annotations
        addAnnotations()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           // Get the first touch
           guard let touch = touches.first else { return }
           
           // Store the touch position
           lastTouchPosition = touch.location(in: self)
       }
       
       override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           // Get the first touch
           guard let touch = touches.first, let lastTouchPosition = lastTouchPosition else { return }
           
           // Calculate the change in touch position
           let newTouchPosition = touch.location(in: self)
           let deltaX = newTouchPosition.x - lastTouchPosition.x
           let deltaY = newTouchPosition.y - lastTouchPosition.y
           
           let minX = -background.size.width / 2 + 350
           let maxX = background.size.width / 2
           let minY = -background.size.height / 2 + 300
           let maxY = background.size.height / 2
           print(minX, maxX)
           
           background.position.x = max(minX, min(maxX, background.position.x + deltaX))
           background.position.y = max(minY, min(maxY, background.position.y + deltaY))
           
           print(background.position)
           
           // Update the last touch position
           self.lastTouchPosition = newTouchPosition
       }
       
       override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           // Reset the last touch position
           lastTouchPosition = nil
       }
    
    func scaleBackground(newScale: CGFloat) {
        guard let background = self.background else {
            return
        }

        // Set the scale of the background node
        let scaleFactor = 1 - (1 - newScale) * 0.05
        print(scaleFactor)
        initialScaleX = max(0.23, min(1, initialScaleX * scaleFactor))
        initialScaleY = max(0.26, min(1, initialScaleY * scaleFactor))

        background.xScale = initialScaleX
        background.yScale = initialScaleY
        //let minScale = min(scaleX, scaleY)
        //background.setScale(minScale)
        print(self.background)
        print("scale success ", self.background.xScale, self.background.yScale)
    }
}
