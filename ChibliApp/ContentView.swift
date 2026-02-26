//
//  ContentView.swift
//  ChibliApp
//
//  Created by Hellen Soloviy on 01.02.2026.
//

import SwiftUI

struct ContentView: View {
    
    @State var filmsViewModel = FilmsViewModel()
    @State var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        TabView {
            Tab("Movies", systemImage: "movieclapper") {
                FilmsScreenView(viewModel: filmsViewModel,
                                favoritesViewModel: favoritesViewModel)
            }
            Tab("Favorites", systemImage: "heart") {
                FavoritesScreenView(viewModel: filmsViewModel,
                                    favoritesViewModel: favoritesViewModel)
            }
            Tab("Settigs", systemImage: "gear") {
                let vm = SettingsViewModel(storageService: FavoriteFilmsStorageService(),
                                           settingsService: SettingsStorageService())
                SettingsScreenView(viewModel: vm)
            }
            
            Tab(role: .search) {
                SearchScreenView(viewModel: SearchScreenViewModel(),
                                 favoritesViewModel: favoritesViewModel)
            }
        }
        .task {
            await filmsViewModel.fetch()
            favoritesViewModel.load()
        }
    }
}

#Preview {
    
    @Previewable @State var vm = FilmsViewModel(service: MockChibliService())
    @Previewable @State var vmFav = FavoritesViewModel(
        storageService: MockFavoriteFilmsStorageService(),
        settingsService: MockSettingsStorageService(languageIndex: 0, shouldShowFavoritesOnMainScreen: true))

    ContentView(filmsViewModel: vm, favoritesViewModel: vmFav)
    
}
