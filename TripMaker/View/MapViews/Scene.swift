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
    var scale = 0.3
    var lastTouchPosition: CGPoint? // Store the last touch position
    var annotations: [AnnotationNode] = []
    
    
    var background: SKSpriteNode!
    var gradientNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        // Add background image
        scene?.size = CGSize(width: 390, height: 310)
        print("init again")
        
        background = SKSpriteNode(imageNamed: "world_map.jpg")
        background.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        //background.scale(to: self.size) // Scale the background to fit the scene
        background.setScale(scale)
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
           //let newPosition = CGPoint(x: max(minX, min(maxX, background.position.x + deltaX)), y: max(minY, min(maxY, background.position.y + deltaY)))
           
           //let moveAction = SKAction.move(to: newPosition, duration: 0.1)
           //background.run(moveAction)
           
           background.position.x = max(minX, min(maxX, background.position.x + deltaX))
           background.position.y = max(minY, min(maxY, background.position.y + deltaY))
           
           print(background.position)
           
           for annot in annotations {
               let newPosX = (background.xScale / 0.3) * annot.relativePosition.x + background.position.x
               let newPosY = (background.yScale / 0.3) * annot.relativePosition.y + background.position.y
               let newPosition = CGPoint(x: newPosX, y: newPosY)
               let moveAction = SKAction.move(to: newPosition, duration: 0.01)
               annot.run(moveAction)
           }
           
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

        // Create the move action to adjust the position
        let moveAction = SKAction.move(to: newPosition, duration: 0.3)
        
        // Group the scaling and moving actions
        let groupAction = SKAction.group([scaleAction, moveAction])

        // Run the group action on the background node
        background.run(groupAction)
        
        
        for annot in annotations {
            let scale = max(min(newScale / scale * 0.05, 0.1), 0.05)
            let scaleAction = SKAction.scale(to: scale, duration: 0.3)
            annot.scale = scale
            
            let newPosX_a = (newScale / 0.3) * annot.relativePosition.x + newPosX
            let newPosY_a = (newScale / 0.3) * annot.relativePosition.y + newPosY
            let newPosition = CGPoint(x: newPosX_a, y: newPosY_a)
            let moveAction = SKAction.move(to: newPosition, duration: 0.3)
            
            // Group the scaling and moving actions
            let groupAction = SKAction.group([scaleAction, moveAction])

            // Run the group action on the background node
            annot.run(groupAction)
        }
        
        //print(self.background)
        //print("scale success ", self.background.xScale, self.background.yScale)
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
                annot.selected.toggle()
                if annot.selected {
                    annot.annotationTapped()
                } else {
                    annot.annotationUntapped()
                }
            } else {
                annot.selected = false
                annot.annotationUntapped()
            }
        }
    }
}
