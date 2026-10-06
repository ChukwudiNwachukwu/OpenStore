# OpenStore for iOS

A native SwiftUI recreation inspired by the supplied OpenStore screenshot. Requires iOS 17 or later. No third-party runtime dependencies.

Includes a dark Discover screen, illustrated feature cards, searchable catalog, category browsing, project details, external website/source links, sharing, persistent bookmarks, and light/dark appearance. The bottom navigation adapts the screenshot to native safe areas without Safari browser controls.

The bundled catalog contains 15 projects. It is not synchronized with openstore.site. Trending shows editorial selections, and New shows reverse catalog order; neither claims live analytics or release dates. Project icons use SF Symbols rather than official logos. This app is a discovery catalog, not an app installer.

## Open locally on a Mac

Install Xcode and XcodeGen, then run:

```sh
brew install xcodegen
xcodegen generate
open OpenStore.xcodeproj
```

Choose the OpenStore scheme and an iPhone simulator. Run with Command-R; run the catalog tests with Command-U.

## Build an unsigned IPA with GitHub

Push this directory's contents to the repository root, including `.github/workflows/ios.yml`. In GitHub, open **Actions → Build unsigned iOS app → Run workflow**. Pushes to main, master, and codex branches also trigger the workflow.

The macOS workflow generates the Xcode project, runs tests on an available iPhone simulator, captures a native screenshot, and builds the device app with signing disabled. Download **OpenStore-unsigned** from the completed run's Artifacts section to obtain `OpenStore-unsigned.ipa` and `OpenStore.png`.

An unsigned IPA needs signing with an appropriate certificate and provisioning profile before installation on a physical iPhone. No Apple signing credentials are needed to build this unsigned artifact. GitHub Actions must be enabled with macOS runner time available on the account.

To build on a Mac directly:

```sh
bash scripts/build-unsigned.sh
```

For your own signed app, change `PRODUCT_BUNDLE_IDENTIFIER` in `project.yml`, regenerate the project, and select your signing team in Xcode.

## Validation status

Source and workflow configuration were checked in the Linux authoring workspace. Xcode compilation, simulator tests, and the native screenshot require the macOS workflow; they have not yet run. The included XCTest suite covers replacement searches, category intersections, whitespace handling, saved-only results, and catalog integrity.
