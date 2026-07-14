import SwiftUI

struct QuizCardView: View {
    let questions: [QuizQuestion]
    @Environment(AppState.self) private var appState

    @State private var currentIndex: Int = 0
    @State private var selectedAnswer: Int? = nil
    @State private var isComplete: Bool = false

    private var palette: AppPalette {
        AppPalette(rawValue: appState.selectedPaletteIndex) ?? .stoneware
    }

    private var currentQuestion: QuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Label("Quick quiz", systemImage: "questionmark.circle.fill")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.5))
                    .textCase(.uppercase)
                    .tracking(0.8)

                Spacer()

                // Progress dots
                HStack(spacing: 6) {
                    ForEach(0..<questions.count, id: \.self) { i in
                        Circle()
                            .fill(i < currentIndex ? palette.accentTextColor : (i == currentIndex ? .white.opacity(0.8) : .white.opacity(0.2)))
                            .frame(width: 6, height: 6)
                            .animation(.easeInOut(duration: 0.2), value: currentIndex)
                    }
                }
            }

            if isComplete {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(palette.accentTextColor)
                    Text("Quiz complete — great work!")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else if let question = currentQuestion {
                // Question
                Text(question.question)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                // Options
                VStack(spacing: 8) {
                    ForEach(0..<question.options.count, id: \.self) { index in
                        QuizOptionButton(
                            text: question.options[index],
                            state: optionState(for: index),
                            palette: palette
                        ) {
                            guard selectedAnswer == nil else { return }
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedAnswer = index
                            }
                            // Advance after delay
                            Task {
                                try? await Task.sleep(for: .seconds(2.5))
                                await MainActor.run {
                                    if currentIndex + 1 < questions.count {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            currentIndex += 1
                                            selectedAnswer = nil
                                        }
                                    } else {
                                        withAnimation { isComplete = true }
                                    }
                                }
                            }
                        }
                    }
                }

                // Explanation
                if let answered = selectedAnswer {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: answered == question.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(answered == question.correctIndex ? .green : .red)
                        Text(question.explanation)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(12)
                    .background(.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .padding(20)
        .glassCard()
    }

    private func optionState(for index: Int) -> QuizOptionState {
        guard let answered = selectedAnswer else { return .unanswered }
        if index == currentQuestion?.correctIndex { return .correct }
        if index == answered { return .incorrect }
        return .disabled
    }
}

enum QuizOptionState { case unanswered, correct, incorrect, disabled }

struct QuizOptionButton: View {
    let text: String
    let state: QuizOptionState
    let palette: AppPalette
    let action: () -> Void

    var backgroundColor: Color {
        switch state {
        case .unanswered: return .white.opacity(0.07)
        case .correct:    return .green.opacity(0.25)
        case .incorrect:  return .red.opacity(0.2)
        case .disabled:   return .white.opacity(0.04)
        }
    }

    var borderColor: Color {
        switch state {
        case .unanswered: return .white.opacity(0.12)
        case .correct:    return .green.opacity(0.6)
        case .incorrect:  return .red.opacity(0.5)
        case .disabled:   return .white.opacity(0.06)
        }
    }

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.callout)
                .foregroundStyle(state == .disabled ? .white.opacity(0.3) : .white.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(borderColor, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .disabled(state != .unanswered)
        .animation(.easeInOut(duration: 0.2), value: state)
    }
}
