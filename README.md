# Astronomy — NASA APOD Viewer

An iOS app that displays NASA's Astronomy Picture of the Day (APOD), built as a take-home assessment.

---

## Requirements

- iOS 18.0+
- Xcode 16+
- Swift 5.10+
- No third-party frameworks

---

## Features

| Feature | Status |
|---|---|
| Today's APOD — date, title, image, explanation | ✅ |
| Video day support via embedded WKWebView | ✅ |
| Tab Bar navigation (iOS 18 Tab API) | ✅ |
| Date picker — load APOD for any chosen date | ✅ |
| Offline cache — last successful entry and image | ✅ |
| iPhone & iPad, both orientations | ✅ |
| Dark Mode | ✅ |
| Dynamic Type & VoiceOver accessibility | ✅ |

---

## Architecture

**MVVM + Coordinator/Router** with a composition root (`AppContainer`).

```
AstronomyApp
└── AppContainer (composition root)
    └── HomeContainer
        ├── APODRepository (network + cache)
        └── ImageService (memory + disk image cache)

AppRouter (tab switching, deep links, session)
└── HomeRouter (push stack, sheet presentation)
└── FeatureRouter
```

### Key Patterns

- **`ViewState<T>`** — generic UI state machine (`idle → loading → loaded / error`)
- **`DataSource<T>`** — repository signals `.fresh` vs `.cached` result; ViewModel has zero cache knowledge
- **`PersistenceProtocol`** — swappable storage layer (`UserDefaultsCache` today, `FileManager` tomorrow)
- **`@Observable @MainActor`** on ViewModels — SwiftUI-native state, main thread safe
- **Composition root** — single `UserDefaultsCache` instance shared between repository and image service; no stale cache mismatches

### Network Layer

```
HTTPClient → RequestBuilder → URLSession
          ← ResponseDecoder ← URLResponse
```

`URLError` is mapped to typed `HTTPError` at the client boundary. Nothing above `HTTPClient` handles `URLError`. `NetworkLogger` redacts query parameters (including API key) in debug builds.

### Image Cache

Three-tier: `NSCache` (memory, 50 MB limit) → `UserDefaults` (disk fallback) → Network.

Network-first strategy: always attempts a fresh load; disk is fallback only on failure. Cached image URL is tracked alongside image data to prevent text/image mismatch between dates.

---

## Testing

Unit tests cover the critical path from network response to UI state:

| Suite | Covers |
|---|---|
| `ResponseDecoderTests` | 2xx decoding, non-2xx errors, invalid JSON |
| `RequestBuilderTests` | GET method, API key, date format, headers, timeout |
| `APODRepositoryTests` | Fresh result, cache fallback, error propagation |
| `HomeViewModelTests` | State transitions, error, retry query, deduplication |

All mocks conform to production protocols — no concrete types referenced in tests.

---

## Known Limitations & Design Decisions

### API Key
The NASA API key is stored as `DEMO_KEY` (NASA's public fallback, rate-limited to 30 req/hour).  
In production this would be injected at build time via `Config.xcconfig` assigned to build configurations — key never touches source control. CI/CD would provide the real key as an environment variable.

### Image Cache — Last Request Only
`ImageService` caches only the most recent image (`lastOnly` mode). This is intentional for the current single-entry requirement. The cached image URL is stored alongside image data so text and image cannot mismatch across date changes.

When list support is added (e.g. date range queries), switching to `.perKey` mode requires a single property change in `HomeContainer` — the architecture already supports it.

### Retry Strategy
Retry is currently manual — the user taps a button to re-trigger the last query. In production this would be complemented with automatic exponential backoff with jitter to handle transient network failures gracefully without hammering the server.

### Localisation
All user-facing strings are currently hardcoded in English. The app has no `Localizable.strings` or `String Catalogue` in place. Adding localisation support is a straightforward next step given strings are already centralised in the accessibility and error layers.
