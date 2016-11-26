//
//  GameScene.swift
//  Psychological
//
//  Created by guanho on 2016. 11. 24..
//  Copyright © 2016년 guanho. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
            label.text = "너는 나에게 어떤 의미일까?"
            label.fontName = "AppleSDGothicNeo-Medium"
            label.fontSize = 45
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            let fadeAction = SKAction.fadeOut(withDuration: 1.0)
            
            label.run(fadeAction, completion: { 
                let sceneTransition = SKTransition.push(with: SKTransitionDirection.left, duration: 1.0)
                let cardScene = CardDisplayScene()
                cardScene.size = (self.view?.bounds.size)!
                self.view?.presentScene(cardScene, transition: sceneTransition)
            })
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
