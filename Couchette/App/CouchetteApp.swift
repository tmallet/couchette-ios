import SwiftUI

@main
struct CouchetteApp: App {
    private let repository: ExploreRepository = MockExploreRepository()

    var body: some Scene {
        WindowGroup {
            ExploreRootView(repository: repository)
        }
    }
}
