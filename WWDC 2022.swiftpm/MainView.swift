import SwiftUI
import SpriteKit

struct MainView: View {
    
    var scene: SKScene {
        let scene = GameView()
        scene.scaleMode = .fill
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        return scene
    }
    
    var body: some View {
            VStack{
                SpriteView(scene: scene)
            }
    }
}
