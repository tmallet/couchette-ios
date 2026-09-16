import Foundation
import Observation

@Observable
@MainActor
final class ExploreViewModel {
    private let repository: ExploreRepository

    var operators: [Operator] = []
    var routes: [Route] = []
    var cabins: [Cabin] = []
    var selectedCabinClass: Cabin.CabinClass? = nil
    var isLoading = false
    var loadError: String?

    init(repository: ExploreRepository) {
        self.repository = repository
    }

    var filteredCabins: [Cabin] {
        guard let selectedCabinClass else { return cabins }
        return cabins.filter { $0.cabinClass == selectedCabinClass }
    }

    func operator(for route: Route) -> Operator? {
        operators.first { $0.id == route.operatorId }
    }

    func route(for cabin: Cabin) -> Route? {
        routes.first { $0.id == cabin.routeId }
    }

    func cabins(for routeId: Route.ID) -> [Cabin] {
        let list = cabins.filter { $0.routeId == routeId }
        guard let selectedCabinClass else { return list }
        return list.filter { $0.cabinClass == selectedCabinClass }
    }

    func primaryCabin(for route: Route) -> Cabin? {
        cabins(for: route.id).first
    }

    func load() async {
        isLoading = true
        loadError = nil
        defer { isLoading = false }
        operators = await repository.operators()
        routes = await repository.routes()
        cabins = await repository.allCabins()
    }

    func cabin(id: Cabin.ID) -> Cabin? {
        cabins.first { $0.id == id }
    }
}
