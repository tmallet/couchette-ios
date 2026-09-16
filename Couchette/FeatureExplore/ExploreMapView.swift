import SwiftUI
import MapKit

struct ExploreMapView: View {
    @Bindable var viewModel: ExploreViewModel
    @Binding var path: NavigationPath

    private let westernEurope = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 50.5, longitude: 6.5),
            span: MKCoordinateSpan(latitudeDelta: 12, longitudeDelta: 14)
        )
    )

    var body: some View {
        Map(initialPosition: westernEurope) {
            ForEach(visibleRoutes) { route in
                Annotation(route.title, coordinate: route.coordinate.clLocationCoordinate) {
                    RouteMapPin(
                        route: route,
                        op: viewModel.operator(for: route)
                    ) {
                        if let cabin = viewModel.primaryCabin(for: route) {
                            path.append(cabin.id)
                        }
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .safeAreaInset(edge: .bottom) {
            cabinFilterBar
        }
        .navigationTitle("Explorer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(CouchetteMaterials.barMaterial, for: .navigationBar)
    }

    private var cabinFilterBar: some View {
        VStack(spacing: 8) {
            Picker("Cabin class", selection: $viewModel.selectedCabinClass) {
                Text("Tous").tag(Cabin.CabinClass?.none)
                ForEach(Cabin.CabinClass.allCases) { cabinClass in
                    Text(cabinClass.label).tag(Optional(cabinClass))
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if visibleRoutes.isEmpty {
                Text("Aucun pin pour ce filtre")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Aucun pin pour ce filtre")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(visibleRoutes) { route in
                            RouteChip(
                                route: route,
                                op: viewModel.operator(for: route)
                            ) {
                                if let cabin = viewModel.primaryCabin(for: route) {
                                    path.append(cabin.id)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical, 10)
        .background(CouchetteMaterials.barMaterial)
    }

    private var visibleRoutes: [Route] {
        if viewModel.selectedCabinClass == nil {
            return viewModel.routes
        }
        return viewModel.routes.filter { !viewModel.cabins(for: $0.id).isEmpty }
    }
}

private struct RouteMapPin: View {
    let route: Route
    let op: Operator?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: op?.brandSymbol ?? "train.side.front.car")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(pinColor, in: Circle())
                    .shadow(radius: 2, y: 1)
                Text(route.cities.first ?? route.title)
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.ultraThinMaterial, in: Capsule())
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(route.title), \(op?.name ?? "")")
    }

    private var pinColor: Color {
        switch op?.id {
        case .some(.nightjet): return CouchetteColors.mapPinNightjet
        case .some(.europeanSleeper): return CouchetteColors.mapPinEuropeanSleeper
        default: return CouchetteColors.brandPrimary
        }
    }
}

private struct RouteChip: View {
    let route: Route
    let op: Operator?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Label(op?.name ?? "Operator", systemImage: op?.brandSymbol ?? "train.side.front.car")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(route.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(route.cities.joined(separator: " · "))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(12)
            .frame(width: 200, alignment: .leading)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private extension Coordinate {
    var clLocationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
