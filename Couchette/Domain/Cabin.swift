import Foundation

/// Bookable cabin / berth product on a route.
public struct Cabin: Identifiable, Hashable, Sendable {
    public let id: ID
    public let routeId: Route.ID
    public let title: String
    public let summary: String
    public let amenities: [String]
    /// Absolute https booking URL (opens in Safari via openURL / Link).
    public let bookingURL: URL
    /// Cabin class filter key used by segmented control.
    public let cabinClass: CabinClass

    public struct ID: Hashable, Sendable, Codable, RawRepresentable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
    }

    public enum CabinClass: String, CaseIterable, Hashable, Sendable, Identifiable {
        case couchette
        case sleeper
        case deluxe

        public var id: String { rawValue }

        public var label: String {
            switch self {
            case .couchette: return "Couchette"
            case .sleeper: return "Sleeper"
            case .deluxe: return "Deluxe"
            }
        }
    }

    public init(
        id: ID,
        routeId: Route.ID,
        title: String,
        summary: String,
        amenities: [String],
        bookingURL: URL,
        cabinClass: CabinClass
    ) {
        self.id = id
        self.routeId = routeId
        self.title = title
        self.summary = summary
        self.amenities = amenities
        self.bookingURL = bookingURL
        self.cabinClass = cabinClass
    }
}
