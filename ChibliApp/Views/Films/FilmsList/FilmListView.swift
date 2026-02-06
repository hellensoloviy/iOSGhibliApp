//
//  FilmListView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 01.02.2026.
//

import SwiftUI

#Preview {
    
    @Previewable @State var vm = FilmsViewModel(service: MockChibliService())
    var vm2 = FavoritesViewModel(storageService: MockFavoriteFilmsStorageService())

    let films = vm.models
    FilmListView(models: films,
                 favoritesViewModel: vm2)
}


struct FilmListView: View {
        
    var models: [Film]
    let favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        
        List(models) { obj in
            NavigationLink(value: obj) { 
                FilmRow(model: obj, favoritesViewModel: favoritesViewModel)
            }
        }
        .navigationDestination(for: Film.self) { obj in
            FilmDetailsView(model: obj)
        }
        
    }
}

private struct FilmRow: View {
    
    var model: Film
    let favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        HStack {
            
            //TODO: - fix placeholder loading frame to be equal
            FilmImageView(urlPath: model.image)
                .frame(width: 100, height: 150)
            Text(model.title)
            
            Button {
                favoritesViewModel.toggleFavorite(filmID: model.id)
            } label: {
                let isFavorite = favoritesViewModel.isFavorite(filmID: model.id)
                Image(systemName: isFavorite ? "hear.fill" : "hear")
            }
            .accessibilityHint("Is Favorite button")
            
        }
    }
    
}

