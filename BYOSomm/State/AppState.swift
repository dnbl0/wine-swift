import Foundation
import Observation

@Observable
final class AppState {
    var selectedPaletteIndex: Int {
        didSet { UserDefaults.standard.set(selectedPaletteIndex, forKey: "byosomm-palette") }
    }
    var userLevel: UserLevel {
        didSet { UserDefaults.standard.set(userLevel.rawValue, forKey: "byosomm-level") }
    }
    var userName: String {
        didSet { UserDefaults.standard.set(userName, forKey: "byosomm-name") }
    }
    var showPaletteSwitcher: Bool = false
    var recentWineIDs: [String] = []

    var selectedPalette: AppPalette {
        AppPalette(rawValue: selectedPaletteIndex) ?? .stoneware
    }

    init() {
        self.selectedPaletteIndex = UserDefaults.standard.object(forKey: "byosomm-palette") as? Int ?? 5
        self.userLevel = UserLevel(rawValue: UserDefaults.standard.string(forKey: "byosomm-level") ?? "") ?? .beginner
        self.userName = UserDefaults.standard.string(forKey: "byosomm-name") ?? "Wine lover"

        if let saved = UserDefaults.standard.array(forKey: "byosomm-recent-ids") as? [String] {
            self.recentWineIDs = saved
        }
    }

    func addToRecent(wineID: String) {
        recentWineIDs.removeAll { $0 == wineID }
        recentWineIDs.insert(wineID, at: 0)
        if recentWineIDs.count > 20 { recentWineIDs = Array(recentWineIDs.prefix(20)) }
        UserDefaults.standard.set(recentWineIDs, forKey: "byosomm-recent-ids")
    }
}

enum UserLevel: String, CaseIterable {
    case beginner    = "Beginner"
    case explorer    = "Explorer"
    case enthusiast  = "Enthusiast"
    case sommelier   = "Sommelier"

    var description: String {
        switch self {
        case .beginner:   return "Just getting started"
        case .explorer:   return "Getting comfortable"
        case .enthusiast: return "Digging deeper"
        case .sommelier:  return "Serious about wine"
        }
    }

    var sfSymbol: String {
        switch self {
        case .beginner:   return "graduationcap"
        case .explorer:   return "map.fill"
        case .enthusiast: return "star.fill"
        case .sommelier:  return "rosette"
        }
    }
}
