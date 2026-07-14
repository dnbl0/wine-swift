import Foundation
import SwiftData

enum WineType: String, CaseIterable, Codable {
    case red = "red"
    case white = "white"
    case rosé = "rosé"
    case sparkling = "sparkling"
    case dessert = "dessert"

    var displayName: String { rawValue.capitalized }

    var dotColor: String {
        switch self {
        case .red: return "WineDotRed"
        case .white: return "WineDotWhite"
        case .rosé: return "WineDotRose"
        case .sparkling: return "WineDotSparkling"
        case .dessert: return "WineDotDessert"
        }
    }

    var sfSymbol: String {
        switch self {
        case .red: return "wineglass.fill"
        case .white: return "wineglass"
        case .rosé: return "heart.fill"
        case .sparkling: return "bubbles.and.sparkles"
        case .dessert: return "drop.fill"
        }
    }
}

enum WineSource: String, Codable {
    case scan = "scan"
    case manual = "manual"
    case sample = "sample"
}

@Model
final class Wine {
    var id: String
    var name: String
    var type: String          // WineType.rawValue
    var vintage: Int
    var region: String
    var country: String
    var grape: String
    var producer: String
    var body: Int             // 1–5
    var tannin: Int           // 1–5
    var acidity: Int          // 1–5
    var sweetness: Int        // 1–5
    var flavours: [String]
    var foodPairings: [String]
    var wineDescription: String
    var notes: String
    var rating: Int           // 0–5
    var savedAt: Date
    var source: String        // WineSource.rawValue
    var isSaved: Bool

    init(
        id: String = UUID().uuidString,
        name: String,
        type: WineType,
        vintage: Int,
        region: String,
        country: String = "Australia",
        grape: String,
        producer: String,
        body: Int,
        tannin: Int,
        acidity: Int,
        sweetness: Int,
        flavours: [String] = [],
        foodPairings: [String] = [],
        wineDescription: String = "",
        notes: String = "",
        rating: Int = 0,
        savedAt: Date = Date(),
        source: WineSource = .manual,
        isSaved: Bool = false
    ) {
        self.id = id
        self.name = name
        self.type = type.rawValue
        self.vintage = vintage
        self.region = region
        self.country = country
        self.grape = grape
        self.producer = producer
        self.body = body
        self.tannin = tannin
        self.acidity = acidity
        self.sweetness = sweetness
        self.flavours = flavours
        self.foodPairings = foodPairings
        self.wineDescription = wineDescription
        self.notes = notes
        self.rating = rating
        self.savedAt = savedAt
        self.source = source.rawValue
        self.isSaved = isSaved
    }

    var wineType: WineType { WineType(rawValue: type) ?? .red }
    var wineSource: WineSource { WineSource(rawValue: source) ?? .manual }
    var vintageDisplay: String { vintage == 0 ? "NV" : String(vintage) }
}
