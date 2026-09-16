# Couchette iOS

Native **SwiftUI** night-train explorer (Slice 1). Not React Native.

## Slice 1 scope

- **Explore** tab with MapKit hubs (FR / Benelux / DE)
- Cabin detail + segmented class filters (Couchette / Sleeper / Deluxe)
- CTA **Continuer** opens real operator booking URLs in Safari (`openURL`)
  - Nightjet → `https://www.nightjet.com/en/ticket-buchen?utm_source=couchette`
  - European Sleeper → `https://www.europeansleeper.eu/?utm_source=couchette`
- Local mock data only (`MockExploreRepository`)

**Out of scope:** API, auth, payment, Android, React Native, rail polylines, in-app booking handoff.

## Requirements

- macOS with Xcode 15+ (iOS 17 deployment target)
- Bundle ID: `com.couchette.app`

## Run

```bash
git clone https://github.com/tmallet/couchette-ios.git
cd couchette-ios
open Couchette.xcodeproj
```

1. Select an **iPhone** simulator (or a device).
2. Product → **Run** (⌘R).

## Modules (folders)

| Folder | Role |
|--------|------|
| `App` | `@main`, composition root |
| `Domain` | `Operator`, `Route`, `Cabin`, `BookingCTA` |
| `Data` | `ExploreRepository` + `MockExploreRepository` |
| `DesignSystem` | Colors, materials (Liquid Glass `#available` / `.ultraThinMaterial`) |
| `FeatureExplore` | TabView, map, cabin detail, CTA |

See `docs/ADR-001-slice1-explore.md` for architecture decisions.

## Mac-only notes

This repository was authored on Linux. The `.xcodeproj` / `project.pbxproj` is hand-written so Xcode on a Mac can open and build it. You cannot run `xcodebuild` or the Simulator on Linux.
