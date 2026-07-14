import SwiftUI
import SwiftData

struct ScanView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ScanViewModel()

    private var palette: AppPalette {
        AppPalette(rawValue: appState.selectedPaletteIndex) ?? .stoneware
    }

    var body: some View {
        ZStack {
            AtmosphericBackground(palette: palette)

            switch viewModel.scanState {
            case .idle:
                ScanIdleView(viewModel: viewModel, palette: palette)
            case .processing(let query):
                ScanProcessingView(query: query, palette: palette)
            case .result(let wine):
                ScanResultView(wine: wine, viewModel: viewModel, palette: palette)
            }
        }
        .navigationTitle("Scan")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct ScanIdleView: View {
    @Bindable var viewModel: ScanViewModel
    let palette: AppPalette
    @Environment(\.modelContext) private var modelContext
    @State private var pulseAnimation: Bool = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Viewfinder
            ZStack {
                // Scan frame
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(palette.accentTextColor.opacity(0.6), lineWidth: 2)
                    .frame(width: 260, height: 200)
                    .overlay(
                        // Corner brackets
                        ScanCornerBrackets(color: palette.accentTextColor)
                    )
                    .scaleEffect(pulseAnimation ? 1.02 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)

                // Sweep line
                ScanSweepLine(color: palette.accentTextColor)

                // Center icon
                Image(systemName: "wineglass.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(palette.accentTextColor.opacity(0.4))
            }
            .onAppear { pulseAnimation = true }

            // Mode chips
            HStack(spacing: 12) {
                ForEach(ScanViewModel.ScanMode.allCases, id: \.self) { mode in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectedMode = mode
                        }
                    } label: {
                        Label(mode.label, systemImage: mode.rawValue)
                            .font(.subheadline)
                            .fontWeight(viewModel.selectedMode == mode ? .semibold : .regular)
                            .foregroundStyle(viewModel.selectedMode == mode ? palette.accentTextColor : .white.opacity(0.5))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 9)
                            .background(
                                Capsule().fill(viewModel.selectedMode == mode ? palette.accentTextColor.opacity(0.2) : Color.white.opacity(0.07))
                                    .overlay(Capsule().strokeBorder(viewModel.selectedMode == mode ? palette.accentTextColor.opacity(0.6) : .white.opacity(0.15), lineWidth: 1))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }

            // Input field
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white.opacity(0.4))
                    TextField("", text: $viewModel.inputText, prompt: Text("e.g. Barossa Shiraz or Riesling").foregroundStyle(.white.opacity(0.3)))
                        .foregroundStyle(.white)
                        .submitLabel(.go)
                        .onSubmit {
                            viewModel.startScan(modelContext: modelContext)
                        }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .darkCard()
                .padding(.horizontal, 24)

                // Quick-pick chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(["Shiraz", "Chardonnay", "Pinot Noir", "Riesling", "Cabernet", "Rosé"], id: \.self) { grape in
                            Button {
                                viewModel.inputText = grape
                                viewModel.startScan(modelContext: modelContext)
                            } label: {
                                Text(grape)
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.7))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(.white.opacity(0.08), in: Capsule())
                                    .overlay(Capsule().strokeBorder(.white.opacity(0.15), lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }

            // Shutter button
            Button {
                viewModel.startScan(modelContext: modelContext)
            } label: {
                ZStack {
                    Circle()
                        .fill(palette.accentTextColor)
                        .frame(width: 70, height: 70)
                        .shadow(color: palette.accentTextColor.opacity(0.5), radius: 12)
                    Image(systemName: "camera.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)
            .disabled(viewModel.inputText.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(viewModel.inputText.trimmingCharacters(in: .whitespaces).isEmpty ? 0.4 : 1)

            Spacer()
        }
    }
}

struct ScanCornerBrackets: View {
    let color: Color
    let length: CGFloat = 24
    let thickness: CGFloat = 3

    var body: some View {
        ZStack {
            // Top left
            Path { p in
                p.move(to: CGPoint(x: 0, y: length))
                p.addLine(to: CGPoint(x: 0, y: 0))
                p.addLine(to: CGPoint(x: length, y: 0))
            }
            .stroke(color, lineWidth: thickness)
            .frame(width: 260, height: 200)
            .offset(x: -130 + length/2, y: -100 + length/2)

            // Top right
            Path { p in
                p.move(to: CGPoint(x: 0, y: 0))
                p.addLine(to: CGPoint(x: length, y: 0))
                p.addLine(to: CGPoint(x: length, y: length))
            }
            .stroke(color, lineWidth: thickness)
            .frame(width: length, height: length)
            .offset(x: 130 - length/2, y: -100 + length/2)

            // Bottom left
            Path { p in
                p.move(to: CGPoint(x: 0, y: 0))
                p.addLine(to: CGPoint(x: 0, y: length))
                p.addLine(to: CGPoint(x: length, y: length))
            }
            .stroke(color, lineWidth: thickness)
            .frame(width: length, height: length)
            .offset(x: -130 + length/2, y: 100 - length/2)

            // Bottom right
            Path { p in
                p.move(to: CGPoint(x: length, y: 0))
                p.addLine(to: CGPoint(x: length, y: length))
                p.addLine(to: CGPoint(x: 0, y: length))
            }
            .stroke(color, lineWidth: thickness)
            .frame(width: length, height: length)
            .offset(x: 130 - length/2, y: 100 - length/2)
        }
    }
}

struct ScanSweepLine: View {
    let color: Color
    @State private var offsetY: CGFloat = -90

    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.clear, color.opacity(0.6), .clear],
                    startPoint: .leading, endPoint: .trailing
                )
            )
            .frame(width: 240, height: 2)
            .offset(y: offsetY)
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
                    offsetY = 90
                }
            }
    }
}

struct ScanProcessingView: View {
    let query: String
    let palette: AppPalette
    @State private var dots: Int = 0

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.8)
                .tint(palette.accentTextColor)

            VStack(spacing: 6) {
                Text("Identifying wine")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Text(query)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ScanResultView: View {
    let wine: Wine
    @Bindable var viewModel: ScanViewModel
    let palette: AppPalette
    @Environment(\.modelContext) private var modelContext
    @State private var isSaved = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Result header
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.title3)
                    Text("Wine identified")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Spacer()
                    Button {
                        viewModel.reset()
                    } label: {
                        Text("Scan again")
                            .font(.caption)
                            .foregroundStyle(palette.accentTextColor)
                    }
                }
                .padding(16)
                .glassCard()
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Wine info card
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(wineTypeColor)
                            .frame(width: 12, height: 12)
                            .padding(.top, 4)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(wine.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text("\(wine.producer) · \(wine.vintageDisplay) · \(wine.region)")
                                .font(.callout)
                                .foregroundStyle(.white.opacity(0.55))
                        }
                    }

                    FlavorBarsView(
                        body_: wine.body, tannin: wine.tannin,
                        acidity: wine.acidity, sweetness: wine.sweetness,
                        accentColor: palette.accentTextColor
                    )

                    Text(wine.wineDescription)
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.75))
                        .lineSpacing(4)

                    if !wine.foodPairings.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PAIRS WITH")
                                .font(.system(size: 10, weight: .bold))
                                .tracking(1)
                                .foregroundStyle(.white.opacity(0.4))
                            FlexibleChips(items: wine.foodPairings, color: .white.opacity(0.6))
                        }
                    }

                    // Actions
                    VStack(spacing: 10) {
                        Button {
                            withAnimation {
                                isSaved = true
                                wine.isSaved = true
                                try? modelContext.save()
                            }
                        } label: {
                            Label(isSaved ? "Saved to cellar" : "Save to cellar", systemImage: isSaved ? "bookmark.fill" : "bookmark")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(isSaved ? palette.accentTextColor.opacity(0.3) : palette.accentTextColor, in: RoundedRectangle(cornerRadius: 14))
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)
                        .disabled(isSaved)
                    }
                }
                .padding(20)
                .glassCard()
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
        }
    }

    private var wineTypeColor: Color {
        switch wine.wineType {
        case .red:       return Color(hex: "#C0442A")
        case .white:     return Color(hex: "#D4AF37")
        case .rosé:      return Color(hex: "#E8769A")
        case .sparkling: return Color(hex: "#A8C8E8")
        case .dessert:   return Color(hex: "#C8884A")
        }
    }
}
