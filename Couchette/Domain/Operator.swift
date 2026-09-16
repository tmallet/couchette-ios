import Foundation

/// Night-train operator brand (pure domain — no UI).
public struct Operator: Identifiable, Hashable, Sendable {
    public let id: ID
    public let name: String
    /// SF Symbol name used as brand mark in UI.
    public let brandSymbol: String

    public struct ID: Hashable, Sendable, Codable, RawRepresentable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
    }

    public init(id: ID, name: String, brandSymbol: String) {
        self.id = id
        self.name = name
        self.brandSymbol = brandSymbol
    }
}

public extension Operator.ID {
    static let nightjet = Operator.ID(rawValue: "nightjet")
    static let europeanSleeper = Operator.ID(rawValue: "europeanSleeper")
}
