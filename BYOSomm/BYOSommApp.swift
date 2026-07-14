import SwiftUI
import SwiftData

@main
struct BYOSommApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: Wine.self)
    }
}
