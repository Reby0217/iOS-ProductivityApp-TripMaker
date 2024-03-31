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
    var lastTouchPosition: CGPoint? // Store the last touch position
    var annotations: [SKNode] = []
    
    
    var background: SKSpriteNode!
    var gradientNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        // Add background image
        scene?.size = CGSize(width: 380, height: 300)
        print("init again")
        
        background = SKSpriteNode(imageNamed: "world_map.jpg")
        background.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        //background.scale(to: self.size) // Scale the background to fit the scene
        background.setScale(0.26)
        background.zPosition = -1
        addChild(background)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        view.addGestureRecognizer(recognizer)
        
        print("set background ", background)
        isUserInteractionEnabled = true
        
        // Add annotations
        addAnnotations()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           // Get the first touch
           guard let touch = touches.first else { return }
           
           // Store the touch position
           lastTouchPosition = touch.location(in: self)
        print("in touches")
       }
       
       override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           // Get the first touch
           guard let touch = touches.first, let lastTouchPosition = lastTouchPosition else { return }
           
           // Calculate the change in touch position
           let newTouchPosition = touch.location(in: self)
           let deltaX = newTouchPosition.x - lastTouchPosition.x
           let deltaY = newTouchPosition.y - lastTouchPosition.y
           
           let minX = -background.size.width / 2 + frame.size.width
           let maxX = background.size.width / 2
           let minY = -background.size.height / 2 + frame.size.height
           let maxY = background.size.height / 2
           
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

        
        let scaleAction = SKAction.scale(to: newScale, duration: 0.3)
        
        let minX = -(background.texture?.size().width)! * newScale / 2 + frame.size.width
        let maxX = (background.texture?.size().width)! * newScale / 2
        let minY = -(background.texture?.size().height)! * newScale / 2 + frame.size.height
        let maxY = (background.texture?.size().height)! * newScale / 2
        
        let newPosX = max(minX, min(maxX, background.position.x))
        let newPosY = max(minY, min(maxY, background.position.y))
        let newPosition = CGPoint(x: newPosX, y: newPosY)
        print(background)
        print("scale: ", newScale)
        print("minX: ", minX, "; maxX: ", maxX)
        print("new position: ", newPosX, newPosY)
        print("old position: ", background.position)

        // Create the move action to adjust the position
        let moveAction = SKAction.move(to: newPosition, duration: 0.3)
        
        // Group the scaling and moving actions
        let groupAction = SKAction.group([scaleAction, moveAction])

        // Run the group action on the background node
        background.run(groupAction)
        
        
        
        for annot in annotations {
            let scale = SKAction.scale(to: max(min(newScale / 0.26 * 0.05, 0.1), 0.05), duration: 0.3)
            annot.run(scale)
        }
        
        print(self.background)
        print("scale success ", self.background.xScale, self.background.yScale)
    }
    
    @objc func tap(_ recognizer: UIGestureRecognizer) {
        print("in")
        let viewLocation = recognizer.location(in: self.view)
        print(viewLocation)
        let sceneLocation = convertPoint(fromView: viewLocation)
        print(sceneLocation)
            
        for annot in annotations {
            print(annot.frame)
            print(annot)
            if annot.contains(sceneLocation) {
                print("scale?")
                let scale = SKAction.scale(to: 0.1, duration: 0.5)
                annot.run(scale)
            } else {
                let scale = SKAction.scale(to: 0.05, duration: 0.5)
                annot.run(scale)
            }
        }
    }
}
