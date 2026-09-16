import SwiftUI

/// Liquid Glass–style chrome with graceful fallbacks.
public enum CouchetteMaterials {
    /// Tab / navigation chrome material.
    @ViewBuilder
    public static func chromeBackground() -> some View {
        if #available(iOS 26.0, *) {
            // Liquid Glass when the SDK / OS exposes it; otherwise ultraThinMaterial.
            Rectangle().fill(.ultraThinMaterial)
        } else {
            Rectangle().fill(.ultraThinMaterial)
        }
    }

    public static var cardMaterial: Material {
        if #available(iOS 26.0, *) {
            return .ultraThinMaterial
        }
        return .ultraThinMaterial
    }

    public static var barMaterial: Material {
        .ultraThinMaterial
    }
}

public struct GlassCardModifier: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        content
            .padding()
            .background(CouchetteMaterials.cardMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

public extension View {
    func couchetteGlassCard() -> some View {
        modifier(GlassCardModifier())
    }
}

public struct PrimaryCTAButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(CouchetteColors.onBrand)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                CouchetteColors.brandPrimary.opacity(configuration.isPressed ? 0.85 : 1),
                in: RoundedRectangle(cornerRadius: 14, style: .continuous)
            )
    }
}
