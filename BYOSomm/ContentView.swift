import SwiftUI

enum AppTab: Int, CaseIterable {
    case home    = 0
    case learn   = 1
    case scan    = 2
    case cellar  = 3
    case account = 4
}

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedTab: AppTab = .home

    var body: some View {
        @Bindable var appState = appState

        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {
                Tab("Home", systemImage: "house.fill", value: .home) {
                    NavigationStack {
                        HomeView()
                    }
                }
                Tab("Learn", systemImage: "book.fill", value: .learn) {
                    NavigationStack {
                        LearnView()
                    }
                }
                Tab("Scan", systemImage: "doc.viewfinder", value: .scan) {
                    NavigationStack {
                        ScanView()
                    }
                }
                Tab("Cellar", systemImage: "wineglass.fill", value: .cellar) {
                    NavigationStack {
                        CellarView()
                    }
                }
                Tab("Profile", systemImage: "person.circle.fill", value: .account) {
                    NavigationStack {
                        AccountView()
                    }
                }
            }
            // iOS 26: TabView + NavigationStack apply Liquid Glass automatically

            // Floating palette switcher overlay
            if appState.showPaletteSwitcher {
                PaletteSwitcherView()
                    .padding(.bottom, 90)
                    .padding(.trailing, 16)
                    .transition(.scale(scale: 0.8, anchor: .bottomTrailing).combined(with: .opacity))
                    .zIndex(100)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: appState.showPaletteSwitcher)
    }
}
