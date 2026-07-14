import SwiftUI

struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    var tintColor: Color = .white.opacity(0.04)

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(tintColor)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.25), .white.opacity(0.06)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 20, tint: Color = .white.opacity(0.04)) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius, tintColor: tint))
    }
}

// Solid dark card variant (for list rows)
struct DarkCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.white.opacity(0.07))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                    )
            )
    }
}

extension View {
    func darkCard(cornerRadius: CGFloat = 16) -> some View {
        modifier(DarkCardModifier(cornerRadius: cornerRadius))
    }
}
