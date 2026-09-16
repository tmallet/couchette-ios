import SwiftUI

/// TabView shell + Explorer NavigationStack (Slice 1: one live tab).
struct ExploreRootView: View {
    @State private var viewModel: ExploreViewModel
    @State private var path = NavigationPath()

    init(repository: ExploreRepository) {
        _viewModel = State(initialValue: ExploreViewModel(repository: repository))
    }

    var body: some View {
        TabView {
            NavigationStack(path: $path) {
                Group {
                    if viewModel.isLoading && viewModel.routes.isEmpty {
                        ProgressView("Chargement…")
                    } else {
                        ExploreMapView(viewModel: viewModel, path: $path)
                    }
                }
                .navigationDestination(for: Cabin.ID.self) { cabinId in
                    if let cabin = viewModel.cabin(id: cabinId) {
                        CabinDetailView(
                            cabin: cabin,
                            route: viewModel.route(for: cabin),
                            op: viewModel.route(for: cabin).flatMap { viewModel.operator(for: $0) }
                        )
                    } else {
                        ContentUnavailableView(
                            "Cabine introuvable",
                            systemImage: "moon.zzz",
                            description: Text("Cette cabine n’est plus dans le catalogue mock.")
                        )
                    }
                }
            }
            .tabItem {
                Label("Explorer", systemImage: "map")
            }

            placeholderTab(title: "Trajets", systemImage: "tram.fill")
            placeholderTab(title: "Profil", systemImage: "person.crop.circle")
        }
        .tint(CouchetteColors.brandPrimary)
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private func placeholderTab(title: String, systemImage: String) -> some View {
        NavigationStack {
            ContentUnavailableView(
                title,
                systemImage: systemImage,
                description: Text("Disponible dans une prochaine slice.")
            )
            .navigationTitle(title)
        }
        .tabItem {
            Label(title, systemImage: systemImage)
        }
        .disabled(true)
        .opacity(0.6)
    }
}
