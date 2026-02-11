//
//  FilmFavoriteButton.swift
//  ChibliApp
//
//  Created by Olena Solovii on 11.02.2026.
//

import SwiftUI

struct FilmFavoriteButton: View {
    
    var filmID: String
    let favoritesViewModel: FavoritesViewModel
    let isLarge: Bool
    
    private var isFavorite: Bool {
        favoritesViewModel.isFavorite(filmID: filmID)
    }
    
    var body: some View {
        Button {
            favoritesViewModel.toggleFavorite(filmID: filmID)
        } label: {
            let isFav = favoritesViewModel.isFavorite(filmID: filmID)
            Image(systemName: isFav ? "heart.fill" : "heart")
                .font(.system(size: isLarge ? 20 : 16))
                .foregroundStyle(isFav ? .pink : .gray)
        }
        .buttonStyle(.borderless) /// to have it react to the taps inside Navigation Link
        .accessibilityHint("Is Favorite button")
    }
}

#Preview {
    FilmFavoriteButton(filmID: "58611129-2dbc-4a81-a72f-77ddfc1b1b49",
                       favoritesViewModel: FavoritesViewModel(storageService: MockFavoriteFilmsStorageService()), isLarge: false)
}
