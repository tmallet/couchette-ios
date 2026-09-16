import Foundation

/// Seeded Nightjet + European Sleeper data for FR / Benelux / DE hubs (Slice 1 smoke).
public final class MockExploreRepository: ExploreRepository, @unchecked Sendable {
    public init() {}

    private static let nightjetBooking = URL(
        string: "https://www.nightjet.com/en/ticket-buchen?utm_source=couchette"
    )!
    private static let europeanSleeperBooking = URL(
        string: "https://www.europeansleeper.eu/?utm_source=couchette"
    )!

    private let seedOperators: [Operator] = [
        Operator(
            id: .nightjet,
            name: "Nightjet",
            brandSymbol: "moon.stars.fill"
        ),
        Operator(
            id: .europeanSleeper,
            name: "European Sleeper",
            brandSymbol: "train.side.front.car"
        )
    ]

    private let seedRoutes: [Route] = [
        // Nightjet — FR / Benelux / DE hubs
        Route(
            id: .init(rawValue: "nj-paris-vienna"),
            operatorId: .nightjet,
            title: "Paris → Vienna",
            cities: ["Paris", "Munich", "Vienna"],
            coordinate: Coordinate(latitude: 48.8566, longitude: 2.3522)
        ),
        Route(
            id: .init(rawValue: "nj-brussels-vienna"),
            operatorId: .nightjet,
            title: "Brussels → Vienna",
            cities: ["Brussels", "Cologne", "Vienna"],
            coordinate: Coordinate(latitude: 50.8503, longitude: 4.3517)
        ),
        Route(
            id: .init(rawValue: "nj-amsterdam-zurich"),
            operatorId: .nightjet,
            title: "Amsterdam → Zurich",
            cities: ["Amsterdam", "Cologne", "Basel", "Zurich"],
            coordinate: Coordinate(latitude: 52.3676, longitude: 4.9041)
        ),
        Route(
            id: .init(rawValue: "nj-berlin-vienna"),
            operatorId: .nightjet,
            title: "Berlin → Vienna",
            cities: ["Berlin", "Prague", "Vienna"],
            coordinate: Coordinate(latitude: 52.5200, longitude: 13.4050)
        ),
        // European Sleeper
        Route(
            id: .init(rawValue: "es-paris-berlin"),
            operatorId: .europeanSleeper,
            title: "Paris → Berlin",
            cities: ["Paris", "Brussels", "Amsterdam", "Berlin"],
            coordinate: Coordinate(latitude: 48.8809, longitude: 2.3553)
        ),
        Route(
            id: .init(rawValue: "es-brussels-prague"),
            operatorId: .europeanSleeper,
            title: "Brussels → Prague",
            cities: ["Brussels", "Amsterdam", "Berlin", "Prague"],
            coordinate: Coordinate(latitude: 50.8350, longitude: 4.3350)
        ),
        Route(
            id: .init(rawValue: "es-brussels-milan"),
            operatorId: .europeanSleeper,
            title: "Brussels → Milan",
            cities: ["Brussels", "Cologne", "Basel", "Milan"],
            coordinate: Coordinate(latitude: 50.8600, longitude: 4.3800)
        )
    ]

    private lazy var seedCabins: [Cabin] = [
        // Nightjet Paris–Vienna
        Cabin(
            id: .init(rawValue: "nj-pv-couchette"),
            routeId: .init(rawValue: "nj-paris-vienna"),
            title: "Couchette 6 berths",
            summary: "Shared couchette compartment on Nightjet Paris–Vienna. Sheets and pillow included.",
            amenities: ["Sheets", "Pillow", "Power socket", "Shared WC"],
            bookingURL: Self.nightjetBooking,
            cabinClass: .couchette
        ),
        Cabin(
            id: .init(rawValue: "nj-pv-sleeper"),
            routeId: .init(rawValue: "nj-paris-vienna"),
            title: "Sleeper 2 berths",
            summary: "Private sleeper cabin with washbasin. Ideal for pairs on the Paris–Vienna Nightjet.",
            amenities: ["Private cabin", "Washbasin", "Towels", "Breakfast"],
            bookingURL: Self.nightjetBooking,
            cabinClass: .sleeper
        ),
        Cabin(
            id: .init(rawValue: "nj-pv-deluxe"),
            routeId: .init(rawValue: "nj-paris-vienna"),
            title: "Deluxe sleeper",
            summary: "Top-tier Nightjet deluxe with en-suite shower and welcome amenities.",
            amenities: ["En-suite shower", "Breakfast", "Welcome drink", "Towels"],
            bookingURL: Self.nightjetBooking,
            cabinClass: .deluxe
        ),
        // Nightjet Brussels–Vienna
        Cabin(
            id: .init(rawValue: "nj-bv-couchette"),
            routeId: .init(rawValue: "nj-brussels-vienna"),
            title: "Couchette 4 berths",
            summary: "Quieter 4-berth couchette on the Brussels–Vienna Nightjet corridor.",
            amenities: ["Sheets", "Pillow", "Reading light"],
            bookingURL: Self.nightjetBooking,
            cabinClass: .couchette
        ),
        Cabin(
            id: .init(rawValue: "nj-bv-sleeper"),
            routeId: .init(rawValue: "nj-brussels-vienna"),
            title: "Sleeper Comfort",
            summary: "Comfort sleeper with seating by day and berths by night.",
            amenities: ["Convertible berths", "Washbasin", "Breakfast"],
            bookingURL: Self.nightjetBooking,
            cabinClass: .sleeper
        ),
        // Nightjet Amsterdam–Zurich
        Cabin(
            id: .init(rawValue: "nj-az-couchette"),
            routeId: .init(rawValue: "nj-amsterdam-zurich"),
            title: "Couchette 6 berths",
            summary: "Classic Nightjet couchette Amsterdam–Zurich via Cologne and Basel.",
            amenities: ["Sheets", "Pillow", "Power socket"],
            bookingURL: Self.nightjetBooking,
            cabinClass: .couchette
        ),
        Cabin(
            id: .init(rawValue: "nj-az-deluxe"),
            routeId: .init(rawValue: "nj-amsterdam-zurich"),
            title: "Deluxe with shower",
            summary: "Deluxe private cabin with shower on the Rhine corridor Nightjet.",
            amenities: ["En-suite shower", "Breakfast", "Quiet coach"],
            bookingURL: Self.nightjetBooking,
            cabinClass: .deluxe
        ),
        // Nightjet Berlin–Vienna
        Cabin(
            id: .init(rawValue: "nj-bev-sleeper"),
            routeId: .init(rawValue: "nj-berlin-vienna"),
            title: "Sleeper 3 berths",
            summary: "Family-friendly sleeper on Nightjet Berlin–Vienna.",
            amenities: ["Washbasin", "Breakfast", "Power socket"],
            bookingURL: Self.nightjetBooking,
            cabinClass: .sleeper
        ),
        // European Sleeper Paris–Berlin
        Cabin(
            id: .init(rawValue: "es-pb-couchette"),
            routeId: .init(rawValue: "es-paris-berlin"),
            title: "Couchette Comfort",
            summary: "European Sleeper couchette Paris–Berlin via Brussels and Amsterdam.",
            amenities: ["Sheets", "Pillow", "Shared facilities"],
            bookingURL: Self.europeanSleeperBooking,
            cabinClass: .couchette
        ),
        Cabin(
            id: .init(rawValue: "es-pb-sleeper"),
            routeId: .init(rawValue: "es-paris-berlin"),
            title: "Private sleeper",
            summary: "Private compartment on European Sleeper Paris–Berlin.",
            amenities: ["Private cabin", "Fresh linen", "Quiet coach"],
            bookingURL: Self.europeanSleeperBooking,
            cabinClass: .sleeper
        ),
        // European Sleeper Brussels–Prague
        Cabin(
            id: .init(rawValue: "es-bp-couchette"),
            routeId: .init(rawValue: "es-brussels-prague"),
            title: "Couchette 5 berths",
            summary: "Budget-friendly couchette Brussels–Prague on European Sleeper.",
            amenities: ["Sheets", "Pillow"],
            bookingURL: Self.europeanSleeperBooking,
            cabinClass: .couchette
        ),
        Cabin(
            id: .init(rawValue: "es-bp-deluxe"),
            routeId: .init(rawValue: "es-brussels-prague"),
            title: "Deluxe cabin",
            summary: "Spacious deluxe cabin on the Brussels–Prague European Sleeper.",
            amenities: ["Private cabin", "Amenities kit", "Priority boarding"],
            bookingURL: Self.europeanSleeperBooking,
            cabinClass: .deluxe
        ),
        // European Sleeper Brussels–Milan
        Cabin(
            id: .init(rawValue: "es-bm-sleeper"),
            routeId: .init(rawValue: "es-brussels-milan"),
            title: "Sleeper Alpine",
            summary: "Sleeper cabin Brussels–Milan via Cologne and Basel.",
            amenities: ["Washbasin", "Fresh linen", "Power socket"],
            bookingURL: Self.europeanSleeperBooking,
            cabinClass: .sleeper
        ),
        Cabin(
            id: .init(rawValue: "es-bm-couchette"),
            routeId: .init(rawValue: "es-brussels-milan"),
            title: "Couchette shared",
            summary: "Shared couchette on European Sleeper Brussels–Milan.",
            amenities: ["Sheets", "Pillow", "Shared WC"],
            bookingURL: Self.europeanSleeperBooking,
            cabinClass: .couchette
        )
    ]

    public func operators() async -> [Operator] { seedOperators }
    public func routes() async -> [Route] { seedRoutes }

    public func cabins(for routeId: Route.ID) async -> [Cabin] {
        seedCabins.filter { $0.routeId == routeId }
    }

    public func cabin(id: Cabin.ID) async -> Cabin? {
        seedCabins.first { $0.id == id }
    }

    public func allCabins() async -> [Cabin] { seedCabins }
}
