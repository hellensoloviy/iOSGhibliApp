//
//  FilmsScreenView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 04.02.2026.
//

import SwiftUI

struct FilmsScreenView: View {
    
    var body: some View {
        FilmListView(viewModel: FilmsViewModel())
    }
}

#Preview {
    FavoritesScreenView()
}
