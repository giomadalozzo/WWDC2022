//
//  File.swift
//  WWDC 20222
//
//  Created by Giovanni Madalozzo on 24/04/22.
//

import Foundation
import SpriteKit
import SwiftUI

class GameOverView: SKScene {
    var tryAgain = SKSpriteNode(imageNamed: "tapTryAgain")
    
    override func didMove(to: SKView){
        var info = SKSpriteNode(imageNamed: "gameOverRIP")
        info.zPosition = 2
        info.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        info.size = CGSize(width: 0.6, height: 0.5)
        info.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)!/1.8)
        addChild(info)
        
        tryAgain.zPosition = 2
        tryAgain.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tryAgain.size = CGSize(width: 0.3, height: 0.15)
        tryAgain.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)!/6)
        addChild(tryAgain)
        
        var background = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
        background.fillColor = UIColor(red: 58/255, green: 75/255, blue: 158/255, alpha: CGFloat(1))
        background.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)!/2)
        background.zPosition = 1
        addChild(background)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if (tryAgain.frame.contains(location)) {
                var scene = GameView()
                scene.scaleMode = .fill
                scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
                let reveal = SKTransition.reveal(with: .up,
                                                 duration: 0.5)
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }
}
