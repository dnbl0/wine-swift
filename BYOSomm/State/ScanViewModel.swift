import Foundation
import Observation
import SwiftData

enum ScanState {
    case idle
    case processing(String)
    case result(Wine)
}

@Observable
final class ScanViewModel {
    var scanState: ScanState = .idle
    var inputText: String = ""
    var selectedMode: ScanMode = .camera

    enum ScanMode: String, CaseIterable {
        case camera  = "camera.fill"
        case type    = "keyboard"

        var label: String {
            switch self {
            case .camera: return "Scan label"
            case .type:   return "Type name"
            }
        }
    }

    func startScan(modelContext: ModelContext) {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let query = inputText
        scanState = .processing(query)

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(Double.random(in: 2.2...3.0)))
            let wine = Self.simulateScan(input: query)
            // Insert into SwiftData
            modelContext.insert(wine)
            try? modelContext.save()
            self.scanState = .result(wine)
        }
    }

    func reset() {
        inputText = ""
        scanState = .idle
    }

    static func simulateScan(input: String) -> Wine {
        let lc = input.lowercased()
        let match: Wine?

        if lc.contains("shiraz") || lc.contains("syrah") {
            match = SampleData.sampleWines.first { $0.grape == "Shiraz" }
        } else if lc.contains("chardonnay") {
            match = SampleData.sampleWines.first { $0.grape == "Chardonnay" && $0.type == WineType.white.rawValue }
        } else if lc.contains("pinot") && !lc.contains("ros") {
            match = SampleData.sampleWines.first { $0.grape == "Pinot Noir" && $0.type == WineType.red.rawValue }
        } else if lc.contains("riesling") {
            match = SampleData.sampleWines.first { $0.grape == "Riesling" }
        } else if lc.contains("ros") {
            match = SampleData.sampleWines.first { $0.type == WineType.rosé.rawValue }
        } else if lc.contains("sparkling") || lc.contains("champagne") || lc.contains("prosecco") || lc.contains("cava") || lc.contains("pet") {
            match = SampleData.sampleWines.first { $0.type == WineType.sparkling.rawValue }
        } else if lc.contains("grenache") {
            match = SampleData.sampleWines.first { $0.grape == "Grenache" }
        } else if lc.contains("cabernet") || lc.contains("cab sauv") {
            match = SampleData.sampleWines.first { $0.grape == "Cabernet Sauvignon" }
        } else if lc.contains("sauvignon") || lc.contains("sauv blanc") {
            match = SampleData.sampleWines.first { $0.grape == "Sauvignon Blanc" }
        } else if lc.contains("muscat") || lc.contains("rutherglen") || lc.contains("dessert") || lc.contains("fortified") {
            match = SampleData.sampleWines.first { $0.type == WineType.dessert.rawValue }
        } else if lc.contains("barossa") {
            match = SampleData.sampleWines.first { $0.region.lowercased().contains("barossa") }
        } else if lc.contains("yarra") {
            match = SampleData.sampleWines.first { $0.region.lowercased().contains("yarra") }
        } else if lc.contains("margaret") {
            match = SampleData.sampleWines.first { $0.region.lowercased().contains("margaret") }
        } else if lc.contains("tasmania") || lc.contains("tas") || lc.contains("jansz") {
            match = SampleData.sampleWines.first { $0.region.lowercased().contains("tas") }
        } else {
            match = nil
        }

        let template = match ?? SampleData.sampleWines[Int.random(in: 0..<SampleData.sampleWines.count)]

        return Wine(
            name: template.name,
            type: template.wineType,
            vintage: template.vintage,
            region: template.region,
            country: template.country,
            grape: template.grape,
            producer: template.producer,
            body: template.body,
            tannin: template.tannin,
            acidity: template.acidity,
            sweetness: template.sweetness,
            flavours: template.flavours,
            foodPairings: template.foodPairings,
            wineDescription: template.wineDescription,
            rating: template.rating,
            source: .scan,
            isSaved: false
        )
    }
}
