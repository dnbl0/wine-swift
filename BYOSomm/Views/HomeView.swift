import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Query(filter: #Predicate<Wine> { $0.isSaved == true }, sort: \Wine.savedAt, order: .reverse)
    private var savedWines: [Wine]

    private var palette: AppPalette {
        AppPalette(rawValue: appState.selectedPaletteIndex) ?? .stoneware
    }

    var body: some View {
        @Bindable var appState = appState

        ZStack {
            AtmosphericBackground(palette: palette)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Hero wordmark
                    HeroWordmark(palette: palette, userLevel: appState.userLevel.rawValue)

                    // Feature tiles
                    FeatureTilesGrid()

                    // Continue learning
                    ContinueLearningSection(palette: palette)

                    // Recent wines
                    if !savedWines.isEmpty {
                        RecentWinesSection(wines: Array(savedWines.prefix(6)), palette: palette)
                    }

                    // Tip card
                    TipCard(palette: palette)

                    Spacer(minLength: 32)
                }
                .padding(.top, 8)
            }
        }
        .navigationTitle("BYO somm")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        appState.showPaletteSwitcher.toggle()
                    }
                } label: {
                    Image(systemName: "paintpalette.fill")
                        .foregroundStyle(palette.accentTextColor)
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct HeroWordmark: View {
    let palette: AppPalette
    let userLevel: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Wordmark
            VStack(alignment: .leading, spacing: 2) {
                Text("BYO")
                    .font(.system(size: 52, weight: .black, design: .default))
                    .foregroundStyle(.white)
                    .tracking(-1)
                Text("somm")
                    .font(.system(size: 52, weight: .black, design: .default))
                    .italic()
                    .foregroundStyle(palette.accentTextColor)
                    .tracking(-1)
            }

            // Level badge
            HStack(spacing: 6) {
                Image(systemName: "graduationcap.fill")
                    .font(.caption2)
                Text(userLevel)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(palette.accentTextColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(palette.accentTextColor.opacity(0.15), in: Capsule())
            .overlay(Capsule().strokeBorder(palette.accentTextColor.opacity(0.4), lineWidth: 1))
        }
        .padding(.horizontal, 20)
    }
}

struct FeatureTilesGrid: View {
    var body: some View {
        VStack(spacing: 12) {
            // Learn — wide tile
            NavigationLink {
                LearnView()
            } label: {
                FeatureTile(
                    title: "Learn",
                    subtitle: "Taste, grape varieties, regions and more",
                    sfSymbol: "book.fill",
                    isWide: true
                )
            }
            .buttonStyle(.plain)

            HStack(spacing: 12) {
                // Scan
                NavigationLink {
                    ScanView()
                } label: {
                    FeatureTile(title: "Scan", subtitle: "Identify any wine", sfSymbol: "doc.viewfinder", isWide: false)
                }
                .buttonStyle(.plain)

                // Cellar
                NavigationLink {
                    CellarView()
                } label: {
                    FeatureTile(title: "Cellar", subtitle: "Your saved wines", sfSymbol: "wineglass.fill", isWide: false)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct FeatureTile: View {
    let title: String
    let subtitle: String
    let sfSymbol: String
    let isWide: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: sfSymbol)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
                    .lineLimit(isWide ? 1 : 2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.3))
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: isWide ? 72 : 90, alignment: .leading)
        .glassCard()
    }
}

struct ContinueLearningSection: View {
    let palette: AppPalette

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Continue learning")

            VStack(spacing: 8) {
                ForEach(SampleData.learnTopics.prefix(3)) { topic in
                    NavigationLink(value: topic) {
                        HStack(spacing: 12) {
                            Image(systemName: topic.sfSymbol)
                                .font(.callout)
                                .foregroundStyle(palette.accentTextColor)
                                .frame(width: 32, height: 32)
                                .background(palette.accentTextColor.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(topic.title)
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                Text("\(topic.readingTime) min read")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.45))
                            }

                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.25))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .darkCard()
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .navigationDestination(for: LearnTopic.self) { topic in
                ArticleView(topic: topic)
            }
        }
    }
}

struct RecentWinesSection: View {
    let wines: [Wine]
    let palette: AppPalette
    @State private var selectedWine: Wine?

    private func typeColor(for wine: Wine) -> Color {
        switch wine.wineType {
        case .red:       return Color(hex: "#C0442A")
        case .white:     return Color(hex: "#D4AF37")
        case .rosé:      return Color(hex: "#E8769A")
        case .sparkling: return Color(hex: "#A8C8E8")
        case .dessert:   return Color(hex: "#C8884A")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Recently saved")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(wines) { wine in
                        Button {
                            selectedWine = wine
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(typeColor(for: wine))
                                        .frame(width: 8, height: 8)
                                    Text(wine.wineType.displayName)
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white.opacity(0.5))
                                }

                                Text(wine.name)
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)

                                Text("\(wine.vintageDisplay) · \(wine.region.components(separatedBy: ",").first ?? wine.region)")
                                    .font(.caption2)
                                    .foregroundStyle(.white.opacity(0.45))
                                    .lineLimit(1)
                            }
                            .frame(width: 160, alignment: .leading)
                            .padding(14)
                            .darkCard()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .sheet(item: $selectedWine) { wine in
            WineDetailSheet(wine: wine)
        }
    }
}

struct TipCard: View {
    let palette: AppPalette
    private let tips = [
        "Chill reds slightly — 16–18°C brings out the best in Barossa Shiraz.",
        "Swirl before you smell. Swirling releases aromatic compounds from the wine.",
        "High acidity = food-friendly. Riesling and Champagne pair well with almost anything.",
        "Old vines produce less fruit, but what they do produce is more concentrated.",
        "The longer the finish, the better the wine — generally.",
    ]
    private var tip: String { tips[Calendar.current.component(.weekOfYear, from: Date()) % tips.count] }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Tip of the week", systemImage: "lightbulb.fill")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(palette.accentTextColor)
                .textCase(.uppercase)
                .tracking(0.8)

            Text(tip)
                .font(.callout)
                .foregroundStyle(.white.opacity(0.8))
                .lineSpacing(3)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
        .padding(.horizontal, 16)
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
    }
}
