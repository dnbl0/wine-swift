import SwiftUI

struct LearnView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedCategory: LearnCategory = .all

    private var palette: AppPalette {
        AppPalette(rawValue: appState.selectedPaletteIndex) ?? .stoneware
    }

    private var filteredTopics: [LearnTopic] {
        if selectedCategory == .all { return SampleData.learnTopics }
        return SampleData.learnTopics.filter { $0.category == selectedCategory }
    }

    var body: some View {
        ZStack {
            AtmosphericBackground(palette: palette)

            VStack(spacing: 0) {
                // Filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(LearnCategory.allCases, id: \.self) { cat in
                            FilterChip(
                                title: cat.displayName,
                                isSelected: selectedCategory == cat,
                                accentColor: palette.accentTextColor
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCategory = cat
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }

                Divider().background(.white.opacity(0.1))

                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredTopics) { topic in
                            NavigationLink(value: topic) {
                                TopicRow(topic: topic, palette: palette)
                            }
                            .buttonStyle(.plain)
                        }

                        // Daily quiz teaser
                        QuizTeaserCard(palette: palette)
                    }
                    .padding(16)
                }
            }
        }
        .navigationTitle("Learn")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(for: LearnTopic.self) { topic in
            ArticleView(topic: topic)
        }
    }
}

struct TopicRow: View {
    let topic: LearnTopic
    let palette: AppPalette

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: topic.sfSymbol)
                .font(.callout)
                .foregroundStyle(palette.accentTextColor)
                .frame(width: 40, height: 40)
                .background(palette.accentTextColor.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(topic.title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Text("\(topic.subtitle) · \(topic.readingTime) min")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.25))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .darkCard()
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? accentColor : .white.opacity(0.6))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? accentColor.opacity(0.2) : Color.white.opacity(0.07))
                        .overlay(Capsule().strokeBorder(isSelected ? accentColor.opacity(0.6) : .white.opacity(0.15), lineWidth: 1))
                )
        }
        .buttonStyle(.plain)
    }
}

struct QuizTeaserCard: View {
    let palette: AppPalette
    @State private var showQuiz = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Label("Quick quiz", systemImage: "questionmark.circle.fill")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(palette.accentTextColor)
                        .textCase(.uppercase)
                        .tracking(0.8)

                    Text("Test your wine knowledge")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "play.fill")
                    .foregroundStyle(palette.accentTextColor)
                    .padding(10)
                    .background(palette.accentTextColor.opacity(0.15), in: Circle())
            }
            .onTapGesture { showQuiz = true }
        }
        .padding(16)
        .glassCard()
        .sheet(isPresented: $showQuiz) {
            QuizCardView(questions: SampleData.quizQuestions)
                .padding(20)
                .presentationDetents([.medium, .large])
                .presentationBackground(.ultraThinMaterial)
                .presentationDragIndicator(.visible)
                .preferredColorScheme(.dark)
        }
    }
}
