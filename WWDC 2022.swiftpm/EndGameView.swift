//
//  File.swift
//  WWDC 20222
//
//  Created by Giovanni Madalozzo on 24/04/22.
//
import Foundation
import SpriteKit

class EndGameView: SKScene {
    var playAgain = SKSpriteNode(imageNamed: "tapPlayAgain")
    
    override func didMove(to: SKView){
        var info = SKSpriteNode(imageNamed: "endScene")
        info.zPosition = 2
        info.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        info.size = CGSize(width: 0.8, height: 0.5)
        info.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)!/1.5)
        addChild(info)
        
        
        playAgain.zPosition = 2
        playAgain.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playAgain.size = CGSize(width: 0.3, height: 0.15)
        playAgain.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)!/5)
        addChild(playAgain)
        
        var thanks = SKLabelNode(fontNamed: "Arial-BoldMT")
        thanks.fontColor = UIColor(red: 246/255, green: 200/255, blue: 68/255, alpha: CGFloat(1))
        thanks.text = "Thank you for playing my game 😁"
        thanks.xScale = 0.002
        thanks.yScale = 0.002
        thanks.fontSize = CGFloat(14)
        thanks.zPosition = 2
        thanks.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)!/16)
        addChild(thanks)
        
        var background = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
        background.fillColor = UIColor(red: 58/255, green: 75/255, blue: 158/255, alpha: CGFloat(1))
        background.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)!/2)
        background.zPosition = 1
        addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if (playAgain.frame.contains(location)) {
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
