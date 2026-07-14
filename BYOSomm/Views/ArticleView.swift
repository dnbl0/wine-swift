import SwiftUI

struct ArticleView: View {
    @Environment(AppState.self) private var appState
    let topic: LearnTopic

    private var palette: AppPalette {
        AppPalette(rawValue: appState.selectedPaletteIndex) ?? .stoneware
    }

    private var article: Article? {
        SampleData.articles.first { $0.id == topic.id }
    }

    var body: some View {
        ZStack {
            AtmosphericBackground(palette: palette)

            if let article = article {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Hero header
                        ArticleHero(article: article, topic: topic, palette: palette)

                        // Intro
                        Text(article.intro)
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.8))
                            .lineSpacing(5)
                            .padding(20)

                        // Facts grid
                        if !article.facts.isEmpty {
                            ArticleFactsGrid(facts: article.facts, palette: palette)
                        }

                        // Expandable sections
                        VStack(spacing: 1) {
                            ForEach(article.sections) { section in
                                ArticleSectionView(section: section)
                            }
                        }
                        .padding(.top, 8)

                        // Quiz
                        let quizQuestions = article.quizIndices.compactMap { idx -> QuizQuestion? in
                            guard idx < SampleData.quizQuestions.count else { return nil }
                            return SampleData.quizQuestions[idx]
                        }
                        if !quizQuestions.isEmpty {
                            QuizCardView(questions: quizQuestions)
                                .padding(16)
                        }

                        Spacer(minLength: 32)
                    }
                }
            } else {
                // Topic has no full article yet
                VStack(spacing: 16) {
                    Image(systemName: topic.sfSymbol)
                        .font(.system(size: 48))
                        .foregroundStyle(palette.accentTextColor)
                    Text(topic.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("Full article coming soon.")
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct ArticleHero: View {
    let article: Article
    let topic: LearnTopic
    let palette: AppPalette

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(palette.primaryColor.opacity(0.35))
                .frame(height: 180)
                .overlay(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.5)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                )

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: topic.sfSymbol)
                        .font(.caption)
                    Text("\(article.readingTime) min read")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white.opacity(0.65))
                .textCase(.uppercase)
                .tracking(0.8)

                Text(article.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .lineLimit(3)
            }
            .padding(20)
        }
    }
}

struct ArticleFactsGrid: View {
    let facts: [ArticleFact]
    let palette: AppPalette

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 1) {
            ForEach(facts) { fact in
                VStack(alignment: .leading, spacing: 3) {
                    Text(fact.label)
                        .font(.system(size: 10, weight: .bold))
                        .textCase(.uppercase)
                        .tracking(0.8)
                        .foregroundStyle(.white.opacity(0.45))
                    Text(fact.value)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(.white.opacity(0.06))
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(.white.opacity(0.12), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

struct ArticleSectionView: View {
    let section: ArticleSection
    @State private var isExpanded: Bool = true

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            Text(section.body)
                .font(.callout)
                .foregroundStyle(.white.opacity(0.75))
                .lineSpacing(5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        } label: {
            Text(section.heading)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
        }
        .disclosureGroupStyle(ArticleDisclosureStyle())
        .background(.white.opacity(0.04))
    }
}

struct ArticleDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack {
                    configuration.label
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.4))
                        .rotationEffect(.degrees(configuration.isExpanded ? 0 : -90))
                        .animation(.easeInOut(duration: 0.2), value: configuration.isExpanded)
                        .padding(.trailing, 20)
                }
            }
            .buttonStyle(.plain)

            if configuration.isExpanded {
                configuration.content
            }
        }
    }
}
