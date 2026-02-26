//
//  FavoritesScreenView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 04.02.2026.
//

import SwiftUI

struct FavoritesScreenView: View {
    
    let viewModel: FilmsViewModel
    let favoritesViewModel: FavoritesViewModel

    
    var models: [Film] {
        let ids = favoritesViewModel.favoriteIDs
        
        switch viewModel.state {
        case .loaded(let models):
            let favs = models.filter({ ids.contains($0.id) })
            return favs
        default:
            return []
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                FilmListView(models: models, favoritesViewModel: favoritesViewModel)
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }

    }
    
}

#Preview {
    @Previewable @State var vm = FilmsViewModel(service: MockChibliService())
    @Previewable @State var vmFav = FavoritesViewModel(
        storageService: MockFavoriteFilmsStorageService(),
        settingsService: MockSettingsStorageService(languageIndex: 0, shouldHideFavoritesOnMainScreen: false))

    FavoritesScreenView(viewModel: vm,
                        favoritesViewModel: vmFav)
    .task {
        await vm.fetch()
        vmFav.load()
    }
}
