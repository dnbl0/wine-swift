import SwiftUI
import SwiftData

struct AccountView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext

    @Query(filter: #Predicate<Wine> { $0.isSaved == true })
    private var savedWines: [Wine]

    @Query private var allWines: [Wine]

    @State private var showLevelPicker = false
    @State private var showClearConfirm = false
    @State private var editingName = false
    @State private var nameInput: String = ""

    private var palette: AppPalette {
        AppPalette(rawValue: appState.selectedPaletteIndex) ?? .stoneware
    }

    var body: some View {
        @Bindable var appState = appState

        ZStack {
            AtmosphericBackground(palette: palette)

            ScrollView {
                VStack(spacing: 20) {
                    // Profile header
                    ProfileHeader(appState: appState, palette: palette, savedCount: savedWines.count, scannedCount: allWines.count)

                    // Settings sections
                    VStack(spacing: 16) {
                        // Preferences
                        SettingsSection(title: "Preferences") {
                            SettingsRow(icon: "graduationcap.fill", label: "Wine level", value: appState.userLevel.rawValue, palette: palette) {
                                showLevelPicker = true
                            }
                            SettingsRow(icon: "paintpalette.fill", label: "Colour palette", value: palette.name, palette: palette) {
                                withAnimation(.spring(response: 0.35)) {
                                    appState.showPaletteSwitcher.toggle()
                                }
                            }
                        }

                        // About
                        SettingsSection(title: "About") {
                            SettingsRow(icon: "info.circle.fill", label: "About BYO somm", value: "v1.0", palette: palette) {}
                            SettingsRow(icon: "star.fill", label: "Rate the app", palette: palette) {}
                        }

                        // Danger zone
                        SettingsSection(title: "Data") {
                            Button {
                                showClearConfirm = true
                            } label: {
                                HStack(spacing: 14) {
                                    Image(systemName: "trash.fill")
                                        .foregroundStyle(.red.opacity(0.8))
                                        .frame(width: 28)
                                    Text("Clear cellar")
                                        .font(.callout)
                                        .foregroundStyle(.red.opacity(0.8))
                                    Spacer()
                                    Text("\(savedWines.count) wines")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.35))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer(minLength: 40)
                }
                .padding(.top, 16)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showLevelPicker) {
            LevelPickerSheet(appState: appState, palette: palette)
                .presentationDetents([.medium])
                .presentationBackground(.ultraThinMaterial)
                .presentationDragIndicator(.visible)
                .preferredColorScheme(.dark)
        }
        .confirmationDialog("Clear all saved wines?", isPresented: $showClearConfirm, titleVisibility: .visible) {
            Button("Clear cellar", role: .destructive) {
                for wine in savedWines { wine.isSaved = false }
                try? modelContext.save()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove \(savedWines.count) wine\(savedWines.count == 1 ? "" : "s") from your cellar.")
        }
    }
}

struct ProfileHeader: View {
    let appState: AppState
    let palette: AppPalette
    let savedCount: Int
    let scannedCount: Int

    var body: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(palette.primaryColor.opacity(0.3))
                    .frame(width: 84, height: 84)
                    .overlay(Circle().strokeBorder(palette.accentTextColor.opacity(0.4), lineWidth: 2))
                Text(String(appState.userName.prefix(1)).uppercased())
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 4) {
                Text(appState.userName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                HStack(spacing: 6) {
                    Image(systemName: appState.userLevel.sfSymbol)
                        .font(.caption2)
                    Text(appState.userLevel.rawValue)
                        .font(.callout)
                    Text("·")
                    Text(appState.userLevel.description)
                        .font(.callout)
                }
                .foregroundStyle(palette.accentTextColor)
            }

            // Stats strip
            HStack(spacing: 0) {
                StatItem(value: "\(savedCount)", label: "Saved", palette: palette)
                Divider().background(.white.opacity(0.15)).frame(height: 32)
                StatItem(value: "\(scannedCount)", label: "Scanned", palette: palette)
                Divider().background(.white.opacity(0.15)).frame(height: 32)
                StatItem(value: "7", label: "Palettes", palette: palette)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .glassCard()
            .padding(.horizontal, 16)
        }
    }
}

struct StatItem: View {
    let value: String
    let label: String
    let palette: AppPalette

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .bold))
                .tracking(0.8)
                .foregroundStyle(.white.opacity(0.4))
                .padding(.horizontal, 4)
                .padding(.bottom, 6)

            VStack(spacing: 1) {
                content
            }
            .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(.white.opacity(0.1), lineWidth: 1))
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let label: String
    var value: String = ""
    let palette: AppPalette
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundStyle(palette.accentTextColor)
                    .frame(width: 28)

                Text(label)
                    .font(.callout)
                    .foregroundStyle(.white)

                Spacer()

                if !value.isEmpty {
                    Text(value)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.4))
                }

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.2))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

struct LevelPickerSheet: View {
    @Bindable var appState: AppState
    @Environment(\.dismiss) private var dismiss
    let palette: AppPalette

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Wine level")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.top, 20)
                .padding(.horizontal, 20)

            VStack(spacing: 8) {
                ForEach(UserLevel.allCases, id: \.self) { level in
                    Button {
                        appState.userLevel = level
                        dismiss()
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: level.sfSymbol)
                                .foregroundStyle(appState.userLevel == level ? palette.accentTextColor : .white.opacity(0.4))
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(level.rawValue)
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                Text(level.description)
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                            Spacer()
                            if appState.userLevel == level {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(palette.accentTextColor)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(appState.userLevel == level ? palette.accentTextColor.opacity(0.1) : Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(appState.userLevel == level ? palette.accentTextColor.opacity(0.4) : .white.opacity(0.1), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
    }
}
