//
//  FilmsScreenView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 04.02.2026.
//

import SwiftUI

#Preview {
    let settings = MockSettingsStorageService(languageIndex: 0, shouldHideFavoritesOnMainScreen: false)

    FilmsScreenView(
        viewModel: FilmsViewModel(service: MockChibliService()),
        favoritesViewModel: FavoritesViewModel(storageService: MockFavoriteFilmsStorageService(), settingsService: settings)
    )
}

struct FilmsScreenView: View {
    
    let viewModel: FilmsViewModel
    let favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    Text("Nothing here yet.")
                    
                case .loaded(let models):
                    FilmListView(models: models, favoritesViewModel: favoritesViewModel)
                        .overlay {
                            if models.isEmpty {
                                ContentUnavailableView {
                                    Label("Nothing to show", systemImage: "moon.dust")
                                } description: {
                                    Text("The list is empty")
                                } actions: {
                                    /// nothing here for now
                                }
                                .offset(y: -60)
                            }
                        }
                    
                case .loading:
                    //TODO: - add effect here
                    ProgressView {
                        Text("Loadig the list...")
                    }
                case .error(let error):
                    Text("Error! \(error.description)")
                        .foregroundStyle(.pink)
                }

            }
            .navigationTitle("Chibli Movies")
            .navigationBarTitleDisplayMode(.large)

        }
        .task {
            await viewModel.fetch()
        }
    }
}


