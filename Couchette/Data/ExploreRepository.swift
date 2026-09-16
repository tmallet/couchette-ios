import Foundation

/// Extension point for live API later; Slice 1 uses MockExploreRepository only.
public protocol ExploreRepository: Sendable {
    func operators() async -> [Operator]
    func routes() async -> [Route]
    func cabins(for routeId: Route.ID) async -> [Cabin]
    func cabin(id: Cabin.ID) async -> Cabin?
    func allCabins() async -> [Cabin]
}
