import SwiftUI

@main
struct GitSearchApp: App {
    var body: some Scene {
        WindowGroup {
			SearchView(viewModel: .init())
        }
    }
}
