import Foundation

struct LearnTopic: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let sfSymbol: String
    let category: LearnCategory
    let readingTime: Int
}

enum LearnCategory: String, CaseIterable {
    case all = "all"
    case gettingStarted = "getting-started"
    case grapes = "grapes"
    case regions = "regions"
    case pairing = "pairing"

    var displayName: String {
        switch self {
        case .all:            return "All"
        case .gettingStarted: return "Getting started"
        case .grapes:         return "Grapes"
        case .regions:        return "Regions"
        case .pairing:        return "Pairing"
        }
    }
}

struct Article: Identifiable {
    let id: String
    let title: String
    let readingTime: Int
    let intro: String
    let sections: [ArticleSection]
    let facts: [ArticleFact]
    let quizIndices: [Int]
}

struct ArticleSection: Identifiable {
    let id = UUID()
    let heading: String
    let body: String
}

struct ArticleFact: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}
