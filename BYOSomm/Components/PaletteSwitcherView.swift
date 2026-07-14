import SwiftUI

struct PaletteSwitcherView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        VStack(alignment: .trailing, spacing: 10) {
            Text(AppPalette(rawValue: appState.selectedPaletteIndex)?.name ?? "")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.ultraThinMaterial, in: Capsule())

            HStack(spacing: 10) {
                ForEach(AppPalette.allCases) { palette in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            appState.selectedPaletteIndex = palette.rawValue
                        }
                    } label: {
                        Circle()
                            .fill(palette.primaryColor)
                            .frame(
                                width: appState.selectedPaletteIndex == palette.rawValue ? 26 : 20,
                                height: appState.selectedPaletteIndex == palette.rawValue ? 26 : 20
                            )
                            .overlay(
                                Circle()
                                    .strokeBorder(.white.opacity(appState.selectedPaletteIndex == palette.rawValue ? 0.8 : 0), lineWidth: 2)
                            )
                            .shadow(color: palette.primaryColor.opacity(0.7), radius: 4)
                    }
                    .buttonStyle(.plain)
                    .frame(minWidth: 36, minHeight: 44)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().strokeBorder(.white.opacity(0.2), lineWidth: 1))
        }
    }
}
