//
//  FavoritesScreenView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 04.02.2026.
//

import SwiftUI

struct FavoritesScreenView: View {
    
    let viewModel: FilmsViewModel
    
    var models: [Film] {
        //TODO: - logic for favorites
        return []
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.models.isEmpty {
                    ContentUnavailableView("No favorites yet", systemImage: "heart")
                } else {
                    FilmListView(models: viewModel.models)
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }

    }
}

#Preview {
    FavoritesScreenView(viewModel: FilmsViewModel(service: MockChibliService()))
}
