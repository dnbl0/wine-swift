import SwiftUI

struct AtmosphericBackground: View {
    let palette: AppPalette

    var body: some View {
        RadialGradient(
            colors: palette.backgroundGradientColors,
            center: UnitPoint(x: 0.45, y: 0.1),
            startRadius: 0,
            endRadius: 600
        )
        .ignoresSafeArea()
    }
}

extension View {
    func atmosphericBackground(_ palette: AppPalette) -> some View {
        self.background(AtmosphericBackground(palette: palette))
    }
}
