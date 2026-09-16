import SwiftUI

struct CabinDetailView: View {
    let cabin: Cabin
    let route: Route?
    let op: Operator?

    @Environment(\.openURL) private var openURL
    @State private var showURLError = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                summaryCard
                amenitiesCard
                cta
            }
            .padding()
        }
        .background(CouchetteColors.softSurface.ignoresSafeArea())
        .navigationTitle(cabin.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(CouchetteMaterials.barMaterial, for: .navigationBar)
        .alert("Impossible d’ouvrir le lien", isPresented: $showURLError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Vérifiez votre connexion ou réessayez plus tard.")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let op {
                Label(op.name, systemImage: op.brandSymbol)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(CouchetteColors.brandPrimary)
            }
            if let route {
                Text(route.title)
                    .font(.title2.weight(.bold))
                Text(route.cities.joined(separator: " → "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(cabin.cabinClass.label)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(CouchetteColors.brandAccent.opacity(0.2), in: Capsule())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .couchetteGlassCard()
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("À propos")
                .font(.headline)
            Text(cabin.summary)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .couchetteGlassCard()
    }

    private var amenitiesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Équipements")
                .font(.headline)
            FlowAmenities(amenities: cabin.amenities)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .couchetteGlassCard()
    }

    private var bookingCTA: BookingCTA {
        cabin.bookingCTA
    }

    private var cta: some View {
        VStack(spacing: 8) {
            Button {
                openBooking()
            } label: {
                Label(bookingCTA.title, systemImage: "arrow.up.right.square")
            }
            .buttonStyle(PrimaryCTAButtonStyle())
            .accessibilityHint("Ouvre le site de l’opérateur dans Safari")

            Text("Ouvre le site de réservation \(op?.name ?? "opérateur")")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }

    private func openBooking() {
        openURL(bookingCTA.url) { accepted in
            if !accepted {
                showURLError = true
            }
        }
    }
}

private struct FlowAmenities: View {
    let amenities: [String]

    var body: some View {
        FlexibleAmenityWrap(amenities: amenities)
    }
}

/// Simple wrapping layout without third-party deps.
private struct FlexibleAmenityWrap: View {
    let amenities: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(amenities, id: \.self) { amenity in
                Label(amenity, systemImage: "checkmark.circle.fill")
                    .font(.subheadline)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(CouchetteColors.brandPrimary, Color.secondary)
            }
        }
    }
}
