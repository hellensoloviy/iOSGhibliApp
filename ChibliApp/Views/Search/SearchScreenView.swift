//
//  SearchScreenView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 04.02.2026.
//

import SwiftUI

#Preview {
    let settings = MockSettingsStorageService(languageIndex: 0, shouldHideFavoritesOnMainScreen: false)

    let vm = SearchScreenViewModel(service: MockChibliService())
    var vmFav = FavoritesViewModel(storageService: MockFavoriteFilmsStorageService(), settingsService: settings)

    SearchScreenView(viewModel: vm, favoritesViewModel: vmFav)
        .task {
            vmFav.load()
        }
}

struct SearchScreenView: View {
    
    @State private var textToSearch: String = ""
    @State var viewModel: SearchScreenViewModel
    
    let favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .idle:
                    SearchScreenIdleView()
                    
                case .loaded(let searchResults):
                    FilmListView(models: searchResults, favoritesViewModel: favoritesViewModel)
                    .overlay {
                        if searchResults.isEmpty && !textToSearch.isEmpty {
                            ContentUnavailableView {
                                Label("Nothing found", systemImage: "tornado")
                            } description: {
                                Text("There was no search resuls to match your request")
                            } actions: {
                                /// nothing here for now
                            }
                            .offset(y: -60)
                        } else if textToSearch.isEmpty {
                            SearchScreenIdleView()
                        }
                    }
                    
                case .loading:
                    ProgressView {
                        Text("Searching...")
                    }
                case .error(let error):
                    Text("Error! \(error.description)")
                        .foregroundStyle(.pink)
                    
                }
            }
            .searchable(text: $textToSearch)
            .task(id: textToSearch) {
                await viewModel.fetch(searchTerm: textToSearch)
            }
        }
    }
}


struct SearchScreenIdleView: View {

    var body: some View {
        ContentUnavailableView {
            Label("Type to search", systemImage: "magnifyingglass")
        } description: {
            Text("Start typing to find what you want")
        } actions: {
            /// nothing here for now
        }
        .offset(y: -60)
    }
}


