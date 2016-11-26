//
//  Card.swift
//  Psychological
//
//  Created by guanho on 2016. 11. 24..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation
import SpriteKit

class Card: SKSpriteNode{
    var front: SKTexture
    var back: SKTexture
    var touched = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(cardName: String) {
        self.front = SKTexture(imageNamed: cardName)
        self.back = SKTexture(imageNamed: cardName+"_back")
        super.init(texture: self.front, color: UIColor.white, size: self.front.size())
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let liftUp = SKAction.scale(to: CardDisplayScene.cardScale * 1.3, duration: 0.2)
        run(liftUp)
        
        let rotateCCW = SKAction.rotate(toAngle: CGFloat(-M_1_PI / 10), duration: 0.1)
        let rotateCW = SKAction.rotate(toAngle: CGFloat(M_1_PI / 10), duration: 0.1)
        let rotate = SKAction.sequence([rotateCCW, rotateCW])
        let rotateRepeat = SKAction.repeatForever(rotate)
        run(rotateRepeat, withKey: "rotate")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dropDown = SKAction.scale(to: CardDisplayScene.cardScale, duration: 0.2)
        run(dropDown)
        removeAction(forKey: "rotate")
        let rotate = SKAction.rotate(toAngle: 0, duration: 0)
        run(rotate)
        
        self.texture = self.back
        
        if !self.touched{
            let fold = SKAction.scaleX(to: 0.0, duration: 0.4)
            let unfold = SKAction.scaleX(to: CardDisplayScene.cardScale, duration: 0.4)
            
            run(fold, completion:{
                self.texture = self.back
                self.run(unfold)
            })
            
            if let sparkParticlePath: String = Bundle.main.path(forResource: "CardSpark", ofType: "sks"){
                let sparkParticleNode = NSKeyedUnarchiver.unarchiveObject(withFile: sparkParticlePath) as! SKEmitterNode
                sparkParticleNode.position = CGPoint(x: 0, y: 0)
                sparkParticleNode.zPosition = 10
                self.addChild(sparkParticleNode)
            }
            
            self.touched = true
        }else{
            let alert = UIAlertController(title: "알림", message: "결과를 공유하시겠습니까?", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "네", style: .default, handler: { (action) in
                self.sharedHandler(action, alert: alert)
            }) 
            let actionCancel = UIAlertAction(title: "아니요", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(actionOk)
            alert.addAction(actionCancel)
            
            self.scene?.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func sharedHandler(_ action: UIAlertAction!, alert: UIAlertController){
        alert.dismiss(animated: true, completion: nil)
        let shareTxt = "당신은 나에게 이런의미...."
        let shareImg = UIImage(cgImage: (self.texture?.cgImage)!())
        let shareItems = [shareTxt, shareImg] as [Any]
        let activityController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.scene?.view?.window?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
}
