import SwiftUI
import SwiftData

struct CellarView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext

    @Query(filter: #Predicate<Wine> { $0.isSaved == true }, sort: \Wine.savedAt, order: .reverse)
    private var savedWines: [Wine]

    @Query(sort: \Wine.savedAt, order: .reverse)
    private var allWines: [Wine]

    @State private var selectedTab: CellarTab = .saved
    @State private var filterType: WineType? = nil
    @State private var selectedWine: Wine? = nil
    @State private var showAddWine: Bool = false

    private var palette: AppPalette {
        AppPalette(rawValue: appState.selectedPaletteIndex) ?? .stoneware
    }

    enum CellarTab: String, CaseIterable {
        case saved  = "Saved"
        case recent = "Recent"
    }

    private var displayedWines: [Wine] {
        let base = selectedTab == .saved ? savedWines : allWines
        guard let filter = filterType else { return base }
        return base.filter { $0.type == filter.rawValue }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AtmosphericBackground(palette: palette)

            VStack(spacing: 0) {
                // Saved/Recent picker
                Picker("", selection: $selectedTab) {
                    ForEach(CellarTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                // Type filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(title: "All", isSelected: filterType == nil, accentColor: palette.accentTextColor) {
                            withAnimation { filterType = nil }
                        }
                        ForEach(WineType.allCases, id: \.self) { type in
                            FilterChip(title: type.displayName, isSelected: filterType == type, accentColor: palette.accentTextColor) {
                                withAnimation { filterType = (filterType == type) ? nil : type }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }

                Divider().background(.white.opacity(0.1))

                if displayedWines.isEmpty {
                    CellarEmptyState(tab: selectedTab, palette: palette)
                } else {
                    List {
                        ForEach(displayedWines) { wine in
                            WineRowView(wine: wine, palette: palette)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                                .onTapGesture {
                                    selectedWine = wine
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                modelContext.delete(displayedWines[index])
                            }
                            try? modelContext.save()
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }

            // FAB — add wine manually
            Button {
                showAddWine = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 60)
                    .background(palette.accentTextColor, in: Circle())
                    .shadow(color: palette.accentTextColor.opacity(0.5), radius: 12)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .navigationTitle("My Cellar")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(item: $selectedWine) { wine in
            WineDetailSheet(wine: wine)
        }
        .sheet(isPresented: $showAddWine) {
            AddWineSheet()
                .presentationDetents([.large])
                .presentationBackground(.ultraThinMaterial)
                .presentationDragIndicator(.visible)
                .preferredColorScheme(.dark)
        }
    }
}

struct CellarEmptyState: View {
    let tab: CellarView.CellarTab
    let palette: AppPalette

    var body: some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: "wineglass")
                .font(.system(size: 48))
                .foregroundStyle(palette.accentTextColor.opacity(0.4))

            Text("No wines yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            Text(tab == .saved
                ? "Save wines from Scan to build your cellar."
                : "Wines you look up will appear here.")
                .font(.callout)
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
    }
}

struct AddWineSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState

    @State private var name: String = ""
    @State private var grape: String = ""
    @State private var producer: String = ""
    @State private var region: String = ""
    @State private var vintage: String = ""
    @State private var selectedType: WineType = .red
    @State private var rating: Int = 3
    @State private var notes: String = ""

    private var palette: AppPalette {
        AppPalette(rawValue: appState.selectedPaletteIndex) ?? .stoneware
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Wine") {
                    TextField("Wine name", text: $name)
                    TextField("Producer", text: $producer)
                    TextField("Grape variety", text: $grape)
                    TextField("Region", text: $region)
                    TextField("Vintage (year)", text: $vintage)
                        .keyboardType(.numberPad)
                }

                Section("Style") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(WineType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                }

                Section("Rating") {
                    StarRatingView(rating: rating, interactive: true, size: 24, onRatingChange: { r in rating = r })
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 4)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("Add Wine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let vintageInt = Int(vintage) ?? 0
                        let wine = Wine(
                            name: name.isEmpty ? "Unnamed wine" : name,
                            type: selectedType,
                            vintage: vintageInt,
                            region: region,
                            country: "Australia",
                            grape: grape,
                            producer: producer,
                            body: 3, tannin: 3, acidity: 3, sweetness: 2,
                            notes: notes,
                            rating: rating,
                            source: .manual,
                            isSaved: true
                        )
                        modelContext.insert(wine)
                        try? modelContext.save()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .fontWeight(.semibold)
                    .foregroundStyle(palette.accentTextColor)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
