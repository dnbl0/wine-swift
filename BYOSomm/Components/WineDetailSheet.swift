import SwiftUI
import SwiftData

struct WineDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState

    let wine: Wine
    @State private var isSaved: Bool

    init(wine: Wine) {
        self.wine = wine
        _isSaved = State(initialValue: wine.isSaved)
    }

    private var palette: AppPalette {
        AppPalette(rawValue: appState.selectedPaletteIndex) ?? .stoneware
    }

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
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(typeColor)
                        .frame(width: 14, height: 14)
                        .shadow(color: typeColor.opacity(0.6), radius: 5)
                        .padding(.top, 4)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(wine.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text("\(wine.producer) · \(wine.vintageDisplay) · \(wine.region)")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    Spacer()
                }
                .padding(20)

                Divider().background(.white.opacity(0.1))

                // Flavor profile
                VStack(alignment: .leading, spacing: 12) {
                    Label("Flavour profile", systemImage: "chart.bar.fill")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.5))
                        .textCase(.uppercase)
                        .tracking(0.8)

                    FlavorBarsView(
                        body_: wine.body, tannin: wine.tannin,
                        acidity: wine.acidity, sweetness: wine.sweetness,
                        accentColor: palette.accentTextColor
                    )
                }
                .padding(20)

                Divider().background(.white.opacity(0.1))

                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text(wine.wineDescription)
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.8))
                        .lineSpacing(4)
                }
                .padding(20)

                // Flavour notes chips
                if !wine.flavours.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Flavour notes", systemImage: "nose.fill")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white.opacity(0.5))
                            .textCase(.uppercase)
                            .tracking(0.8)

                        FlexibleChips(items: wine.flavours, color: palette.accentTextColor)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }

                Divider().background(.white.opacity(0.1))

                // Food pairings
                if !wine.foodPairings.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Pairs with", systemImage: "fork.knife")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white.opacity(0.5))
                            .textCase(.uppercase)
                            .tracking(0.8)

                        FlexibleChips(items: wine.foodPairings, color: .white.opacity(0.6))
                    }
                    .padding(20)
                }

                // Actions
                VStack(spacing: 10) {
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            isSaved.toggle()
                            wine.isSaved = isSaved
                            try? modelContext.save()
                        }
                    } label: {
                        Label(isSaved ? "Saved to cellar" : "Save to cellar", systemImage: isSaved ? "bookmark.fill" : "bookmark")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(isSaved ? palette.accentTextColor.opacity(0.25) : palette.accentTextColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)

                    Button("Close") { dismiss() }
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .background(Color.black.opacity(0.6))
        .presentationDetents([.large])
        .presentationBackground(.ultraThinMaterial)
        .presentationDragIndicator(.visible)
        .preferredColorScheme(.dark)
    }
}

struct FlexibleChips: View {
    let items: [String]
    let color: Color

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(items, id: \.self) { item in
                TagChip(item, color: color)
            }
        }
    }
}

// Simple flow layout for chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
                totalHeight = currentY
            }
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
        totalHeight += lineHeight
        return CGSize(width: maxWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX && currentX > bounds.minX {
                currentX = bounds.minX
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}
