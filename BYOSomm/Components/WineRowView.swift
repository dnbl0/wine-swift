import SwiftUI

struct WineRowView: View {
    let wine: Wine
    let palette: AppPalette

    private var typeColor: Color {
        switch wine.wineType {
        case .red:       return Color(hex: "#C0442A")
        case .white:     return Color(hex: "#D4AF37")
        case .rosé:      return Color(hex: "#E8769A")
        case .sparkling: return Color(hex: "#A8C8E8")
        case .dessert:   return Color(hex: "#C8884A")
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            // Color dot
            Circle()
                .fill(typeColor)
                .frame(width: 12, height: 12)
                .shadow(color: typeColor.opacity(0.6), radius: 4)

            VStack(alignment: .leading, spacing: 3) {
                Text(wine.name)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text("\(wine.vintageDisplay) · \(wine.region.components(separatedBy: ",").first ?? wine.region)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))

                HStack(spacing: 6) {
                    TagChip(wine.wineType.displayName, color: palette.accentTextColor)
                    TagChip(wine.grape, color: .white.opacity(0.35))
                }
            }

            Spacer()

            StarRatingView(rating: wine.rating, size: 11)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .darkCard()
    }
}

struct TagChip: View {
    let text: String
    let color: Color

    init(_ text: String, color: Color = .white.opacity(0.35)) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(color.opacity(0.15), in: Capsule())
            .overlay(Capsule().strokeBorder(color.opacity(0.3), lineWidth: 1))
    }
}
