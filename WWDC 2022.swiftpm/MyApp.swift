import SwiftUI

@main
struct MyApp: App {
    @State var whichView: CurrentView = .intro
    var body: some Scene {
        WindowGroup {
            switch whichView {
            case .intro:
                IntroView(whichView: $whichView)
            case .game:
                MainView()
            }
        }
    }
}


