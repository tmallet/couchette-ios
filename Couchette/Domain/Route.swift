import Foundation

/// Geographic point for map hubs (Domain stays free of MapKit / CoreLocation).
public struct Coordinate: Hashable, Sendable, Codable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

/// A night-train corridor / hub pin for the explore map.
public struct Route: Identifiable, Hashable, Sendable {
    public let id: ID
    public let operatorId: Operator.ID
    public let title: String
    public let cities: [String]
    /// Hub coordinate for MapKit annotation (not a full rail polyline in Slice 1).
    public let coordinate: Coordinate

    public struct ID: Hashable, Sendable, Codable, RawRepresentable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
    }

    public init(
        id: ID,
        operatorId: Operator.ID,
        title: String,
        cities: [String],
        coordinate: Coordinate
    ) {
        self.id = id
        self.operatorId = operatorId
        self.title = title
        self.cities = cities
        self.coordinate = coordinate
    }
}
