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
    
    let films = [service.fetchFilm(), service.fetchFilm()]
    
    //TODO: - check preview behaviour for the shadowing without NavigationStack here ?
    NavigationStack {
        FilmListView(models: films,
                     favoritesViewModel: vm2)
    }
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
        .containerShape(.rect(cornerRadius: 20, style: .continuous))
        
    }
}

private struct FilmRow: View {
    
    var model: Film
    let favoritesViewModel: FavoritesViewModel
    
    private var isFavorite: Bool {
        favoritesViewModel.isFavorite(filmID: model.id)
    }
    
    var body: some View {
        HStack {
            FilmImageView(urlPath: model.image)
                .frame(width: 100, height: 150)
            
                //TODO: - Add tipkip here later
                .onLongPressGesture(minimumDuration: 0.7) {
                    print("Double tapped on \(model.title)")
                    favoritesViewModel.toggleFavorite(filmID: model.id)
                }
//                .highPriorityGesture(
//                    LongPressGesture(minimumDuration: 1.0)
//                        .onEnded {
//                        print("Double tapped on \(model.title)")
//                        favoritesViewModel.toggleFavorite(filmID: model.id)
//                    }
//                )
               
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text(model.title)
                        .font(.title3)
                    
                    Text(model.score)
                        .font(.title2)
                        .foregroundStyle(model.scoreInt > 50 ? .green : .orange)
                    +
                    Text(" / 100")
                    
                    Divider()
                    
                    HStack {
                        
                        Text("Directed by ")
                            .foregroundStyle(.gray.opacity(0.99))
                        +
                        Text(model.director)
                    }
                    .font(.caption)
                    
                    HStack {
                        
                        Text("Producer ")
                            .foregroundStyle(.gray.opacity(0.99))
                        + Text(model.producer)
                    }
                    .font(.caption)
                    
                    HStack {
                        Text("Released ")
                            .foregroundStyle(.gray.opacity(0.99))
                        +
                        Text(model.releaseYear)
                    }
                    .font(.caption)
                    
                }
                .padding(.bottom)
                
                
                Button {
                    favoritesViewModel.toggleFavorite(filmID: model.id)
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundStyle(isFavorite ? .pink : .gray)
                }
                .controlSize(.large)
                .buttonStyle(.borderless) /// to have it react to the taps inside Navigation Link
                .accessibilityHint("Is Favorite button")
                
            }
            
        }
        
    }
    
}

