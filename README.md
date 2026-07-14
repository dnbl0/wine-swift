# BYO somm — iOS App

Native SwiftUI iOS app. Australian wine companion — scan, learn, track.

**Stack:** iOS 26 · Swift 6 · SwiftUI · SwiftData · @Observable

---

## Open in Xcode

1. **Open Xcode 26** → File → New → Project → iOS → **App**
2. Product name: `BYOSomm` · Bundle ID: `com.yourname.byosomm`
3. Language: **Swift** · Interface: **SwiftUI** · Storage: **None** (we use SwiftData manually)
4. Save to `/Users/dean.noble/Documents/BYOSomm/`

Xcode will create a default project with `ContentView.swift` and `<AppName>App.swift`. Delete them both.

5. In Xcode's file navigator, right-click the `BYOSomm` group → **Add Files to "BYOSomm"…**
6. Navigate to `/Users/dean.noble/Documents/BYOSomm/BYOSomm/`
7. Select all folders: `Models/`, `Data/`, `State/`, `Views/`, `Components/`
8. Also add `BYOSommApp.swift` and `ContentView.swift` from the root
9. ✓ **Copy items if needed** | ✓ **Create groups** | Target: BYOSomm → **Add**

---

## Project structure

```
BYOSomm/
├── BYOSommApp.swift          @main entry point, ModelContainer, AppState
├── ContentView.swift         TabView (5 tabs — iOS 26 Liquid Glass tab bar)
│
├── Models/
│   ├── Wine.swift            @Model Wine + WineType/WineSource enums
│   ├── AppPalette.swift      7 palettes with dark atmospheric gradients
│   ├── LearnContent.swift    LearnTopic, Article, ArticleSection, ArticleFact
│   └── QuizQuestion.swift    Quiz question struct
│
├── Data/
│   └── SampleData.swift      12 Australian wines · 9 topics · 3 articles · 12 quiz Qs
│
├── State/
│   ├── AppState.swift        @Observable global state (palette, level, name)
│   └── ScanViewModel.swift   @Observable scan state machine
│
├── Views/
│   ├── HomeView.swift        Wordmark · feature tiles · continue learning · recent wines
│   ├── LearnView.swift       Filter chips · topic list · quiz teaser
│   ├── ArticleView.swift     Hero · facts grid · expandable sections · inline quiz
│   ├── ScanView.swift        Animated viewfinder · 3-state scan (idle/processing/result)
│   ├── CellarView.swift      Saved/Recent tabs · filter · list · FAB add wine
│   └── AccountView.swift     Profile · level picker · palette switcher · settings
│
└── Components/
    ├── AtmosphericBackground.swift   Dark radial gradient per palette
    ├── GlassCard.swift               .regularMaterial + specular border modifier
    ├── FlavorBarsView.swift          Animated flavor profile bars (spring)
    ├── WineRowView.swift             Wine list row with color dot + stars
    ├── WineDetailSheet.swift         Full detail modal sheet
    ├── PaletteSwitcherView.swift     Floating palette dots overlay
    ├── QuizCardView.swift            Inline quiz with progress + answer state
    └── StarRatingView.swift          Read-only + interactive star ratings
```

---

## Design

| Layer | Approach |
|---|---|
| Navigation bar + Tab bar | iOS 26 Liquid Glass — automatic, zero code |
| Content cards | `.regularMaterial` + white 0.18 opacity border |
| Scan shutter / FAB | `palette.accentTextColor` filled circle |
| Background | `RadialGradient` — saturated mid-tone → near-black (wine cellar atmosphere) |
| Palette switching | 7 palettes, persisted in `UserDefaults`, live-updated via `AppState` |

---

## Minimum deployment target

Set **iOS 26.0** in Xcode target settings (General → Deployment Info).

This is required for:
- iOS 26 `Tab()` API in TabView
- Automatic Liquid Glass on navigation + tab bar
- `.toolbarColorScheme(.dark)` behaviour
- SwiftData (iOS 17+, but palette APIs need 26)
