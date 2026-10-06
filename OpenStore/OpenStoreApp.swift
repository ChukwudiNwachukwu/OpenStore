import SwiftUI

@main
struct OpenStoreApp: App {
    @AppStorage("lightAppearance") private var lightAppearance = false

    var body: some Scene {
        WindowGroup {
            StoreView()
                .preferredColorScheme(lightAppearance ? .light : .dark)
                .tint(.mint)
        }
    }
}
