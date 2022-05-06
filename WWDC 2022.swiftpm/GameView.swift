import SpriteKit
import SwiftUI

import GameplayKit
import AVFoundation

class GameView: SKScene {
    
    private var player: SKSpriteNode = SKSpriteNode(imageNamed: "spaceship")
    
    private var map: SKSpriteNode = SKSpriteNode()
    
    private var tree1: SKSpriteNode = SKSpriteNode(imageNamed: "tree2")
    private var tree2: SKSpriteNode = SKSpriteNode(imageNamed: "tree2")
    private var tree3: SKSpriteNode = SKSpriteNode(imageNamed: "tree2")
    private var tree4: SKSpriteNode = SKSpriteNode(imageNamed: "tree1")
    private var tree5: SKSpriteNode = SKSpriteNode(imageNamed: "tree1")
    private var tree6: SKSpriteNode = SKSpriteNode(imageNamed: "tree1")
    
    private var stone1: SKSpriteNode = SKSpriteNode(imageNamed: "stone1")
    private var stone2: SKSpriteNode = SKSpriteNode(imageNamed: "stone1")
    private var stone3: SKSpriteNode = SKSpriteNode(imageNamed: "stone1")
    private var stone4: SKSpriteNode = SKSpriteNode(imageNamed: "stone2")
    private var stone5: SKSpriteNode = SKSpriteNode(imageNamed: "stone2")
    private var stone6: SKSpriteNode = SKSpriteNode(imageNamed: "stone2")
    
    private var house1: SKSpriteNode = SKSpriteNode(imageNamed: "house1")
    private var house2: SKSpriteNode = SKSpriteNode(imageNamed: "house1")
    private var house3: SKSpriteNode = SKSpriteNode(imageNamed: "house1")
    private var house4: SKSpriteNode = SKSpriteNode(imageNamed: "house2")
    private var house5: SKSpriteNode = SKSpriteNode(imageNamed: "house2")
    private var house6: SKSpriteNode = SKSpriteNode(imageNamed: "house2")
    
    private var ally1: SKSpriteNode = SKSpriteNode(imageNamed: "5_1")
    private var ally1Animation: [SKTexture] = [SKTexture]()
    private var ally2: SKSpriteNode = SKSpriteNode(imageNamed: "7_1")
    private var ally2Animation: [SKTexture] = [SKTexture]()
    private var ally3: SKSpriteNode = SKSpriteNode(imageNamed: "11_1")
    private var ally3Animation: [SKTexture] = [SKTexture]()
    private var ally4: SKSpriteNode = SKSpriteNode(imageNamed: "13_1")
    private var ally4Animation: [SKTexture] = [SKTexture]()
    private var ally5: SKSpriteNode = SKSpriteNode(imageNamed: "15_1")
    private var ally5Animation: [SKTexture] = [SKTexture]()
    private var ally6: SKSpriteNode = SKSpriteNode(imageNamed: "19_1")
    private var ally6Animation: [SKTexture] = [SKTexture]()
    private var ally7: SKSpriteNode = SKSpriteNode(imageNamed: "20_1")
    private var ally7Animation: [SKTexture] = [SKTexture]()
    private var ally8: SKSpriteNode = SKSpriteNode(imageNamed: "23_1")
    private var ally8Animation: [SKTexture] = [SKTexture]()
    private var ally9: SKSpriteNode = SKSpriteNode(imageNamed: "25_1")
    private var ally9Animation: [SKTexture] = [SKTexture]()
    
    private var collectedAllies: Int = 0
    
    private var baseJoystick: SKShapeNode = SKShapeNode(circleOfRadius: 0.09)
    private var buttonJoystick: SKSpriteNode = SKSpriteNode(imageNamed: "ControllerPosition")
    private var diffJoystickX: CGFloat?
    private var diffJoystickY: CGFloat?
    private var diffCounterX: CGFloat?
    private var diffCounterY: CGFloat?
    private var diffTimerX: CGFloat?
    private var diffTimerY: CGFloat?
    
    private var joystickPoint: CGPoint?
    var stickActive: Bool = false
    
    var movementEnabled: Bool = false
    
    var xMove: CGFloat = CGFloat(0)
    var yMove: CGFloat = CGFloat(0)
    
    private lazy var cameraNode: SKCameraNode = {
        let cameraNode = SKCameraNode()
        cameraNode.zPosition = 10
        cameraNode.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)!/2)
        return cameraNode
    }()
    
    let soundFileSpaceshipURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "spaceship-audio", ofType: ".mp3")!)
    var spaceshipSound: AVAudioPlayer!
    
    let soundFileScreamURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "scream", ofType: ".mp3")!)
    var screamSound: AVAudioPlayer!
    
    let soundAlienURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "alien-voice", ofType: ".mp3")!)
    var alienSound: AVAudioPlayer!
    
    let timerNode: SKLabelNode = SKLabelNode(fontNamed: "Arial-BoldMT")
    let allyCounterNode: SKLabelNode = SKLabelNode(fontNamed: "Arial-BoldMT")
    var time: Int = 120
    {
        didSet{
            if collectedAllies == 9 {
                endGame()
            }
            if time <= 0 && collectedAllies != 9{
                gameOver()
            }
            if time>=10{
                timerNode.text = "Timer: \(time)"
                allyCounterNode.text = "Collected allies: \(collectedAllies)"
            }else{
                timerNode.text = "Timer: 0\(time)"
                allyCounterNode.text = "Collected allies: \(collectedAllies)"
                timerNode.fontColor = .red
            }
        }
    }
    
    func countdown() -> Void {
        time -= 1
        
        if time <= 0{
            print("acabou")
        }
    }
    
    
    override func didMove(to: SKView){
        do
        {
            spaceshipSound = try AVAudioPlayer(contentsOf: soundFileSpaceshipURL as URL, fileTypeHint: nil)
            screamSound = try AVAudioPlayer(contentsOf: soundFileScreamURL as URL, fileTypeHint: nil)
            alienSound = try AVAudioPlayer(contentsOf: soundAlienURL as URL, fileTypeHint: nil)
            spaceshipSound.numberOfLoops = -1
            spaceshipSound.play()
            spaceshipSound.setVolume(0.1, fadeDuration: 0.1)
            
            screamSound.setVolume(0.07, fadeDuration: 0.1)
            alienSound.setVolume(0.08, fadeDuration: 0.1)
        }
        catch let error as NSError
        {
            print(error.description)
        }
        
        camera = cameraNode
        addChild(cameraNode)
        
        createMap()
        createMapDetails()
        createAllies()
        joystick()
        createPlayer()
        createTimer()
        createCounter()
        time = 120
        
        self.diffJoystickX = self.player.position.x - self.buttonJoystick.position.x
        self.diffJoystickY = self.player.position.y - self.buttonJoystick.position.y
        self.diffTimerX = self.player.position.x - self.timerNode.position.x
        self.diffTimerY = self.player.position.y - self.timerNode.position.y
        self.diffCounterX = self.player.position.x - self.allyCounterNode.position.x
        self.diffCounterY = self.player.position.x - self.allyCounterNode.position.y
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(countdown),SKAction.wait(forDuration: 1)])))
    }
    
    func createTimer(){
        timerNode.zPosition = 10
        timerNode.xScale = 0.002
        timerNode.yScale = 0.002
        timerNode.position  = CGPoint(x: buttonJoystick.position.x+0.72, y: buttonJoystick.position.y+0.77)
        timerNode.fontSize = 20
        addChild(timerNode)
    }
    
    func createCounter(){
        allyCounterNode.zPosition = 10
        allyCounterNode.xScale = 0.002
        allyCounterNode.yScale = 0.002
        allyCounterNode.position  = CGPoint(x: buttonJoystick.position.x+0.05, y: buttonJoystick.position.y+0.77)
        allyCounterNode.fontSize = 20
        addChild(allyCounterNode)
    }
    
    func makeNoiseMap(columns: Int, rows: Int) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = 0.9
        
        let noise = GKNoise(source)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0.0, 0.0)
        let sampleCount = vector2(Int32(columns), Int32(rows))
        
        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        movementEnabled = true
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if (buttonJoystick.frame.contains(location)) {
                stickActive = true
            }else{
                stickActive = false
            }
        }
        
        if self.movementEnabled && self.stickActive {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                
                self.cameraNode.position = CGPoint(x: self.cameraNode.position.x - self.xMove*0.1, y: self.cameraNode.position.y + self.yMove*0.1)
                self.player.position = CGPoint(x: self.player.position.x - self.xMove*0.1, y: self.player.position.y + self.yMove*0.1)
                self.baseJoystick.position = CGPoint(x: self.baseJoystick.position.x - self.xMove*0.1, y: self.baseJoystick.position.y + self.yMove*0.1)
                self.buttonJoystick.position = CGPoint(x: self.buttonJoystick.position.x - self.xMove*0.1, y: self.buttonJoystick.position.y + self.yMove*0.1)
                
                self.timerNode.position = CGPoint(x: self.player.position.x - self.diffTimerX!, y: self.player.position.y - self.diffTimerY!)
                self.allyCounterNode.position = CGPoint(x: self.player.position.x - self.diffCounterX!, y: self.player.position.y - self.diffCounterY!)
                
                
                if self.player.contains(self.ally1.position){
                    self.ally1.removeFromParent()
                    self.ally1.position = CGPoint(x: 99999, y: 999999)
                    self.alienSound.play()
                    self.collectedAllies += 1
                }
                if self.player.contains(self.ally2.position){
                    self.ally2.removeFromParent()
                    self.ally2.position = CGPoint(x: 99999, y: 999999)
                    self.alienSound.play()
                    self.collectedAllies += 1
                }
                if self.player.contains(self.ally3.position){
                    self.ally3.removeFromParent()
                    self.ally3.position = CGPoint(x: 99999, y: 999999)
                    self.alienSound.play()
                    self.collectedAllies += 1
                }
                if self.player.contains(self.ally4.position){
                    self.ally4.removeFromParent()
                    self.ally4.position = CGPoint(x: 99999, y: 999999)
                    self.alienSound.play()
                    self.collectedAllies += 1
                }
                if self.player.contains(self.ally5.position){
                    self.ally5.removeFromParent()
                    self.ally5.position = CGPoint(x: 99999, y: 999999)
                    self.alienSound.play()
                    self.collectedAllies += 1
                }
                if self.player.contains(self.ally6.position){
                    self.ally6.removeFromParent()
                    self.ally6.position = CGPoint(x: 99999, y: 999999)
                    self.alienSound.play()
                    self.collectedAllies += 1
                }
                if self.player.contains(self.ally7.position){
                    self.ally7.removeFromParent()
                    self.ally7.position = CGPoint(x: 99999, y: 999999)
                    self.alienSound.play()
                    self.collectedAllies += 1
                }
                if self.player.contains(self.ally8.position){
                    self.ally8.removeFromParent()
                    self.ally8.position = CGPoint(x: 99999, y: 999999)
                    self.alienSound.play()
                    self.collectedAllies += 1
                }
                if self.player.contains(self.ally9.position){
                    self.ally9.removeFromParent()
                    self.ally9.position = CGPoint(x: 99999, y: 999999)
                    self.alienSound.play()
                    self.collectedAllies += 1
                }
                
                if self.player.contains(self.house1.position){
                    self.screamSound.play()
                    self.gameOver()
                }
                if self.player.contains(self.house2.position){
                    self.screamSound.play()
                    self.gameOver()
                }
                if self.player.contains(self.house3.position){
                    self.screamSound.play()
                    self.gameOver()
                }
                if self.player.contains(self.house4.position){
                    self.screamSound.play()
                    self.gameOver()
                }
                if self.player.contains(self.house5.position){
                    self.screamSound.play()
                    self.gameOver()
                }
                if self.player.contains(self.house6.position){
                    self.screamSound.play()
                    self.gameOver()
                }
                
                
                if self.player.position.x > 1.60{
                    self.player.position.x = 1.60
                    self.cameraNode.position.x = 1.60
                    self.buttonJoystick.position.x = 1.60 - self.diffJoystickX!
                    self.baseJoystick.position.x = 1.60 - self.diffJoystickX!
                }
                if self.player.position.x < -0.6{
                    self.player.position.x = -0.6
                    self.cameraNode.position.x = -0.6
                    self.buttonJoystick.position.x = -0.6 - self.diffJoystickX!
                    self.baseJoystick.position.x = -0.6 - self.diffJoystickX!
                }
                if self.player.position.y > 1.60{
                    self.player.position.y = 1.60
                    self.cameraNode.position.y = 1.60
                    self.buttonJoystick.position.y = 1.60 - self.diffJoystickY!
                    self.baseJoystick.position.y = 1.60 - self.diffJoystickY!
                }
                if self.player.position.y < -0.6{
                    self.player.position.y = -0.6
                    self.cameraNode.position.y = -0.6
                    self.buttonJoystick.position.y = -0.6 - self.diffJoystickY!
                    self.baseJoystick.position.y = -0.6 - self.diffJoystickY!
                }
                //                print(self.player.position)
                if !self.movementEnabled {
                    timer.invalidate()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if stickActive {
            
            for touch in touches {
                let location = touch.location(in: self)
                
                let vector = CGVector(dx: location.x - baseJoystick.position.x, dy: location.y - baseJoystick.position.y)
                let angle = atan2(vector.dy, vector.dx)
                
                let xDistance: CGFloat = sin(angle-(Double.pi/2)) * baseJoystick.frame.size.width/2
                let yDistance: CGFloat = cos(angle-(Double.pi/2)) * baseJoystick.frame.size.width/2
                
                self.xMove = xDistance
                self.yMove = yDistance
                
                if (baseJoystick.contains(location)) {
                    buttonJoystick.position = location
                }else{
                    buttonJoystick.position = CGPoint(x: baseJoystick.position.x - xDistance, y: baseJoystick.position.y + yDistance)
                }
                
                player.zRotation = angle
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movementEnabled = false
        self.yMove = CGFloat(0)
        self.xMove = CGFloat(0)
        
        if stickActive {
            let move:SKAction = SKAction.move(to: baseJoystick.position, duration: 0.2)
            move.timingMode = .easeOut
            buttonJoystick.run(move)
        }
    }
    
    func createMap(){
        map.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
        map.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        map.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)!/2)
        map.zPosition = 0
        
        addChild(map)
        map.xScale = 0.0002
        map.yScale = 0.0002
        
        let tileSet = SKTileSet(named: "Sample Grid Tile Set")!
        let tileSize = CGSize(width: 128, height: 128)
        let columns = 128
        let rows = 128
        
        let waterTiles = tileSet.tileGroups.first { $0.name == "Water" }
        let grassTiles = tileSet.tileGroups.first { $0.name == "Grass"}
        let sandTiles = tileSet.tileGroups.first { $0.name == "Sand"}
        
        let bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        bottomLayer.fill(with: sandTiles)
        
        map.addChild(bottomLayer)
        
        let noiseMap = makeNoiseMap(columns: columns, rows: rows)
        
        let topLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        
        topLayer.enableAutomapping = true
        
        map.addChild(topLayer)
        
        
        
        for column in 0 ..< columns {
            for row in 0 ..< rows {
                let location = vector2(Int32(row), Int32(column))
                let terrainHeight = noiseMap.value(at: location)
                
                if terrainHeight < 0 {
                    topLayer.setTileGroup(waterTiles, forColumn: column, row: row)
                } else {
                    topLayer.setTileGroup(grassTiles, forColumn: column, row: row)
                }
            }
        }
    }
    
    func joystick() {
        self.joystickPoint = CGPoint(x: (self.scene!.size.width)/6.5, y: (self.scene!.size.height)/6)
        
        baseJoystick.alpha = CGFloat(0.35)
        baseJoystick.zPosition = 9
        baseJoystick.glowWidth = 0
        baseJoystick.fillColor = SKColor.white
        baseJoystick.strokeColor = SKColor.clear
        baseJoystick.position = self.joystickPoint!
        baseJoystick.physicsBody?.isDynamic = false
        
        buttonJoystick.zPosition = 10
        buttonJoystick.position = self.joystickPoint!
        buttonJoystick.size = CGSize(width: 0.09, height: 0.09)
        buttonJoystick.physicsBody?.isDynamic = false
        
        self.addChild(baseJoystick)
        self.addChild(buttonJoystick)
        
    }
    
    func createPlayer() {
        player.size = CGSize(width: 0.1, height: 0.1)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)!/2)
        player.zPosition = 1
        player.color = .white
        player.name = "player"
        addChild(player)
    }
    
    func createMapDetails(){
        stone1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        stone1.position = CGPoint(x: 0.79, y: 0.49)
        stone1.size = CGSize(width: 0.05, height: 0.04)
        addChild(stone1)
        
        stone2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        stone2.position = CGPoint(x: 1.12, y: 1.02)
        stone2.size = CGSize(width: 0.05, height: 0.04)
        addChild(stone2)
        
        stone3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        stone3.position = CGPoint(x: 0.99, y: -0.14)
        stone3.size = CGSize(width: 0.05, height: 0.04)
        addChild(stone3)
        
        stone4.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        stone4.position = CGPoint(x: -0.03, y: -0.06)
        stone4.size = CGSize(width: 0.05, height: 0.04)
        addChild(stone4)
        
        stone5.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        stone5.position = CGPoint(x: -0.17, y: 0.89)
        stone5.size = CGSize(width: 0.05, height: 0.04)
        addChild(stone5)
        
        stone6.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        stone6.position = CGPoint(x: 0.4, y: 1.32)
        stone6.size = CGSize(width: 0.05, height: 0.04)
        addChild(stone6)
        
        house1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        house1.position = CGPoint(x: 0.66, y: 0.82)
        house1.size = CGSize(width: 0.06, height: 0.1)
        addChild(house1)
        
        house2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        house2.position = CGPoint(x: 1.38, y: 0.4)
        house2.size = CGSize(width: 0.06, height: 0.1)
        addChild(house2)
        
        house3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        house3.position = CGPoint(x: -0.1, y: 1.31)
        house3.size = CGSize(width: 0.06, height: 0.1)
        addChild(house3)
        
        house4.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        house4.position = CGPoint(x: 0.56, y: 1.14)
        house4.size = CGSize(width: 0.09, height: 0.1)
        addChild(house4)
        
        house5.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        house5.position = CGPoint(x: 0.28, y: -0.37)
        house5.size = CGSize(width: 0.09, height: 0.1)
        addChild(house5)
        
        house6.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        house6.position = CGPoint(x: -0.42, y: 0.47)
        house6.size = CGSize(width: 0.09, height: 0.1)
        addChild(house6)
        
        tree1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tree1.position = CGPoint(x: 0.21, y: 0.1)
        tree1.size = CGSize(width: 0.03, height: 0.1)
        addChild(tree1)
        
        tree2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tree2.position = CGPoint(x: 1.15, y: 0.04)
        tree2.size = CGSize(width: 0.03, height: 0.1)
        addChild(tree2)
        
        tree3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tree3.position = CGPoint(x: 0.44, y: -0.49)
        tree3.size = CGSize(width: 0.03, height: 0.1)
        addChild(tree3)
        
        tree4.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tree4.position = CGPoint(x: 1.24, y: 1.2)
        tree4.size = CGSize(width: 0.03, height: 0.1)
        addChild(tree4)
        
        tree5.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tree5.position = CGPoint(x: -0.26, y: 0.28)
        tree5.size = CGSize(width: 0.03, height: 0.1)
        addChild(tree5)
        
        tree6.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tree6.position = CGPoint(x: 0.21, y: 1.34)
        tree6.size = CGSize(width: 0.03, height: 0.1)
        addChild(tree6)
    }
    
    func createAllies(){
        for index in 1..<5 {
            let textureName = "5_" + String(index)
            ally1Animation.append(SKTexture(imageNamed: textureName))
        }
        
        ally1.zPosition = 1
        ally1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ally1.position = CGPoint(x: 0.89, y: 0.34)
        ally1.size = CGSize(width: 0.03, height: 0.04)
        ally1.name = "ally"
        addChild(ally1)
        
        ally1.run(SKAction.repeatForever(SKAction.animate(with: ally1Animation, timePerFrame: 0.1, resize: false, restore: false)))
        
        for index in 1..<7 {
            let textureName = "7_" + String(index)
            ally2Animation.append(SKTexture(imageNamed: textureName))
        }
        
        ally2.zPosition = 1
        ally2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ally2.position = CGPoint(x: 1.5, y: 0.076)
        ally2.size = CGSize(width: 0.03, height: 0.04)
        addChild(ally2)
        
        ally2.run(SKAction.repeatForever(SKAction.animate(with: ally2Animation, timePerFrame: 0.1, resize: false, restore: false)))
        
        for index in 1..<5 {
            let textureName = "11_" + String(index)
            ally3Animation.append(SKTexture(imageNamed: textureName))
        }
        
        ally3.zPosition = 1
        ally3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ally3.position = CGPoint(x: 1.1, y: -0.409)
        ally3.size = CGSize(width: 0.03, height: 0.04)
        addChild(ally3)
        
        ally3.run(SKAction.repeatForever(SKAction.animate(with: ally3Animation, timePerFrame: 0.1, resize: false, restore: false)))
        
        for index in 1..<5 {
            let textureName = "13_" + String(index)
            ally4Animation.append(SKTexture(imageNamed: textureName))
        }
        
        ally4.zPosition = 1
        ally4.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ally4.position = CGPoint(x: 0.57, y: -0.24)
        ally4.size = CGSize(width: 0.03, height: 0.04)
        addChild(ally4)
        
        ally4.run(SKAction.repeatForever(SKAction.animate(with: ally4Animation, timePerFrame: 0.1, resize: false, restore: false)))
        
        for index in 1..<5 {
            let textureName = "15_" + String(index)
            ally5Animation.append(SKTexture(imageNamed: textureName))
        }
        
        ally5.zPosition = 1
        ally5.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ally5.position = CGPoint(x: -0.07, y: -0.44)
        ally5.size = CGSize(width: 0.03, height: 0.04)
        addChild(ally5)
        
        ally5.run(SKAction.repeatForever(SKAction.animate(with: ally5Animation, timePerFrame: 0.1, resize: false, restore: false)))
        
        for index in 1..<5 {
            let textureName = "19_" + String(index)
            ally6Animation.append(SKTexture(imageNamed: textureName))
        }
        
        ally6.zPosition = 1
        ally6.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ally6.position = CGPoint(x: -0.109, y: 0.34)
        ally6.size = CGSize(width: 0.03, height: 0.04)
        addChild(ally6)
        
        ally6.run(SKAction.repeatForever(SKAction.animate(with: ally6Animation, timePerFrame: 0.1, resize: false, restore: false)))
        
        for index in 1..<7 {
            let textureName = "20_" + String(index)
            ally7Animation.append(SKTexture(imageNamed: textureName))
        }
        
        ally7.zPosition = 1
        ally7.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ally7.position = CGPoint(x: -0.35, y: 1.33)
        ally7.size = CGSize(width: 0.03, height: 0.04)
        addChild(ally7)
        
        ally7.run(SKAction.repeatForever(SKAction.animate(with: ally7Animation, timePerFrame: 0.1, resize: false, restore: false)))
        
        for index in 1..<6 {
            let textureName = "23_" + String(index)
            ally8Animation.append(SKTexture(imageNamed: textureName))
        }
        
        ally8.zPosition = 1
        ally8.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ally8.position = CGPoint(x: 0.9, y: 1.3)
        ally8.size = CGSize(width: 0.03, height: 0.04)
        addChild(ally8)
        
        ally8.run(SKAction.repeatForever(SKAction.animate(with: ally8Animation, timePerFrame: 0.1, resize: false, restore: false)))
        
        for index in 1..<6 {
            let textureName = "25_" + String(index)
            ally9Animation.append(SKTexture(imageNamed: textureName))
        }
        
        ally9.zPosition = 1
        ally9.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ally9.position = CGPoint(x: 1.1, y: -0.409)
        ally9.size = CGSize(width: 0.03, height: 0.04)
        addChild(ally9)
        
        ally9.run(SKAction.repeatForever(SKAction.animate(with: ally9Animation, timePerFrame: 0.1, resize: false, restore: false)))
    }
    
    func gameOver(){
        self.player.position = CGPoint(x: 99999999, y: 999999)
        self.spaceshipSound.stop()
        
        var scene = GameOverView()
        scene.scaleMode = .fill
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        let reveal = SKTransition.reveal(with: .up,
                                         duration: 0.5)
        self.view?.presentScene(scene, transition: reveal)
    }
    
    func endGame(){
        self.spaceshipSound.stop()
        var scene = EndGameView()
        scene.scaleMode = .fill
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        let reveal = SKTransition.reveal(with: .up,
                                         duration: 0.5)
        self.view?.presentScene(scene, transition: reveal)
    }
}

