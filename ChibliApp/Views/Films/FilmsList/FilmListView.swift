//
//  FilmListView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 01.02.2026.
//

import SwiftUI

#Preview {
    
    var service = MockChibliService()
    var vm2 = FavoritesViewModel(storageService: MockFavoriteFilmsStorageService())
    
    let films = [service.fetchFilm()]
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
        .overlay {
            if models.isEmpty {
                ContentUnavailableView {
                    Label("Nothing to show", systemImage: "moon.dust")
                } description: {
                    Text("There is no films to view")
                } actions: {
                    /// nothing here for now
                }
                .offset(y: -60)
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
                Image(systemName: isFavorite ? "heart.fill" : "heart")
            }
            .accessibilityHint("Is Favorite button")
            
        }
    }
    
}

