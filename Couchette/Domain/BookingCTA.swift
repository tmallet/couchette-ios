import Foundation

/// CTA payload for opening an operator booking page (Slice 1 = external Safari).
public struct BookingCTA: Hashable, Sendable {
    public let title: String
    public let url: URL

    public init(title: String, url: URL) {
        self.title = title
        self.url = url
    }

    public static func continuer(url: URL) -> BookingCTA {
        BookingCTA(title: "Continuer", url: url)
    }
}
