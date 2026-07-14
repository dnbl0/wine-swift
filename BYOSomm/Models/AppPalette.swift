import SwiftUI

enum AppPalette: Int, CaseIterable, Identifiable {
    case inkAndCream = 0
    case freshPress = 1
    case electricGrape = 2
    case sunAndStone = 3
    case slateAndBlush = 4
    case stoneware = 5
    case station = 6

    var id: Int { rawValue }

    var name: String {
        switch self {
        case .inkAndCream:    return "Ink & cream"
        case .freshPress:     return "Fresh press"
        case .electricGrape:  return "Electric grape"
        case .sunAndStone:    return "Sun & stone"
        case .slateAndBlush:  return "Slate & blush"
        case .stoneware:      return "Stoneware"
        case .station:        return "Station"
        }
    }

    // Primary accent color for each palette
    var primaryColor: Color {
        switch self {
        case .inkAndCream:    return Color(hex: "#B34A2C")
        case .freshPress:     return Color(hex: "#2F6B4F")
        case .electricGrape:  return Color(hex: "#6D3FC4")
        case .sunAndStone:    return Color(hex: "#A84D2C")
        case .slateAndBlush:  return Color(hex: "#37505F")
        case .stoneware:      return Color(hex: "#A5623F")
        case .station:        return Color(hex: "#23306B")
        }
    }

    // Dot color (slightly lighter for visibility on dark bg)
    var dotColor: Color {
        switch self {
        case .inkAndCream:    return Color(hex: "#D4644A")
        case .freshPress:     return Color(hex: "#4A9B74")
        case .electricGrape:  return Color(hex: "#9B6EE8")
        case .sunAndStone:    return Color(hex: "#D46B44")
        case .slateAndBlush:  return Color(hex: "#5A8099")
        case .stoneware:      return Color(hex: "#C8845E")
        case .station:        return Color(hex: "#4A62B0")
        }
    }

    // Dark atmospheric gradient stops (wine cellar atmosphere)
    // RadialGradient from center (mid-tone) → outer (near-black)
    var backgroundGradientColors: [Color] {
        switch self {
        case .inkAndCream:
            return [Color(hex: "#5C2210"), Color(hex: "#2A1008"), Color(hex: "#100403")]
        case .freshPress:
            return [Color(hex: "#0E3A24"), Color(hex: "#061C10"), Color(hex: "#020A06")]
        case .electricGrape:
            return [Color(hex: "#4A1E8A"), Color(hex: "#1C0A40"), Color(hex: "#0A0420")]
        case .sunAndStone:
            return [Color(hex: "#5C2812"), Color(hex: "#2A1008"), Color(hex: "#100403")]
        case .slateAndBlush:
            return [Color(hex: "#1A2E3A"), Color(hex: "#0A161E"), Color(hex: "#04080C")]
        case .stoneware:
            return [Color(hex: "#6B3A20"), Color(hex: "#2E1A0E"), Color(hex: "#120A04")]
        case .station:
            return [Color(hex: "#1A2560"), Color(hex: "#0A0F2E"), Color(hex: "#060818")]
        }
    }

    // Card surface overlay tint (very subtle, on top of .regularMaterial)
    var cardTint: Color {
        primaryColor.opacity(0.08)
    }

    // Text accent on dark backgrounds
    var accentTextColor: Color {
        dotColor
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
