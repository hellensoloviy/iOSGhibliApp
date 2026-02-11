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
                FilmsScreenView(viewModel: filmsViewModel, favoritesViewModel: favoritesViewModel)
            }
            Tab("Favorites", systemImage: "heart") {
                FavoritesScreenView(viewModel: filmsViewModel, favoritesViewModel: favoritesViewModel)
            }
            Tab("Settigs", systemImage: "gear") {
                SettingsScreenView()
            }
            
            Tab(role: .search) {
                SearchScreenView()
            }
        }
        .task {
            favoritesViewModel.load()
        }
    }
}

#Preview {
    
    @Previewable @State var vm = FilmsViewModel(service: MockChibliService())
    @Previewable @State var vmFav = FavoritesViewModel(storageService: MockFavoriteFilmsStorageService())

    ContentView(filmsViewModel: vm, favoritesViewModel: vmFav)
    
}
