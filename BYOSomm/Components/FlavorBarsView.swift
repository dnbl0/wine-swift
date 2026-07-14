import SwiftUI

struct FlavorBarsView: View {
    let body_: Int
    let tannin: Int
    let acidity: Int
    let sweetness: Int
    let accentColor: Color

    @State private var animationProgress: CGFloat = 0

    private var rows: [(String, Int)] {
        [("Sweetness", sweetness), ("Tannin", tannin), ("Acidity", acidity), ("Body", body_)]
    }

    var body: some View {
        VStack(spacing: 10) {
            ForEach(rows, id: \.0) { label, value in
                HStack(spacing: 12) {
                    Text(label)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.white.opacity(0.6))
                        .frame(width: 72, alignment: .leading)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.12))
                                .frame(height: 6)

                            RoundedRectangle(cornerRadius: 3)
                                .fill(accentColor)
                                .frame(width: geo.size.width * (CGFloat(value) / 5.0) * animationProgress, height: 6)
                        }
                    }
                    .frame(height: 6)

                    Text("\(value)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(width: 14, alignment: .trailing)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.72).delay(0.1)) {
                animationProgress = 1
            }
        }
        .onChange(of: body_) { _, _ in triggerAnimation() }
    }

    private func triggerAnimation() {
        animationProgress = 0
        withAnimation(.spring(response: 0.8, dampingFraction: 0.72).delay(0.05)) {
            animationProgress = 1
        }
    }
}
