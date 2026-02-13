//
//  FilmDetailsView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 02.02.2026.
//

import SwiftUI

#Preview {
    let service = MockChibliService()
    let film = service.fetchFilm()
    var vm2 = FavoritesViewModel(storageService: MockFavoriteFilmsStorageService())

    NavigationStack {
        FilmDetailsView(favoritedViewModel: vm2, model: film)
    }
}


struct FilmDetailsView: View {
    
    @State var viewModel: FilmDetailsViewModel = FilmDetailsViewModel()
    
    let favoritedViewModel: FavoritesViewModel
    let model: Film

    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                
                FilmImageView(urlPath: model.bannerImage)
                    .frame(height: 300)
                    .containerRelativeFrame(.horizontal)
                
                //            VStack {
                //
                //            }
                //            .navigationTitle(model.title)
                //            .navigationBarTitleDisplayMode(.large)
                
                VStack(alignment: .leading) {
                    
                    Text("Characters/Cast")
                        .font(.title3)
                    
                    Divider()
                    
                    switch viewModel.state {
                    case .idle:
                        EmptyView()
                        
                    case .loaded(let people):
                        ForEach(people) { obj in
                            NavigationLink(value: obj) {
                                Text(obj.name)
                            }
                        }
                        .overlay {
                            if people.isEmpty {
                                ContentUnavailableView {
                                    Label("Nothing to show", systemImage: "moon.dust")
                                } description: {
                                    Text("The list of the cast is empty")
                                } actions: {
                                    /// nothing here for now
                                }
                                .offset(y: -60)
                            }
                        }
                        
                    case .loading:
                        ProgressView {
                            Text("Loadig the details...")
                        }
                    case .error(let error):
                        Text("Error! \(error.description)")
                            .foregroundStyle(.pink)
                        
                    }
                }
                .padding()
                
            }
            .toolbar {
                FilmFavoriteButton(filmID: model.id, favoritesViewModel: favoritedViewModel, isLarge: false)
            }

            /// If we add here task(id: model) with model inside it will update the task when the model is changed;
            /// Now we do not track any changes here so we can leave it just task {}
            /// when we search for example, this can lessen the times it runs
            .task(id: model) {
                await viewModel.fetch(for: model)
            }

        }
        
    }
}
