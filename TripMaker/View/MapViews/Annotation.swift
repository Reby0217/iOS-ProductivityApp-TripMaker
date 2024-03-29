//
//  Annotation.swift
//  TripMaker
//
//  Created by Megan Lin on 3/28/24.
//

import Foundation
import SpriteKit

// Custom annotation node representing a pin on the map
class AnnotationNode: SKNode {
    init(imageNamed: String) {
        super.init()
        
        let pinSprite = SKSpriteNode(imageNamed: imageNamed)
        addChild(pinSprite)
        
        // Offset the pin so it points to the correct position
        pinSprite.position = CGPoint(x: 0, y: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapScene {
    func addAnnotations() {
        // Create and add annotation nodes
        let annotation1 = AnnotationNode(imageNamed: "reward.jpg")
        annotation1.setScale(0.05)
        annotation1.position = CGPoint(x: 100, y: 100)
        addChild(annotation1)
            
        let annotation2 = AnnotationNode(imageNamed: "reward.jpg")
        annotation2.setScale(0.05)
        annotation2.position = CGPoint(x: 200, y: 200)
        addChild(annotation2)
    }
}
