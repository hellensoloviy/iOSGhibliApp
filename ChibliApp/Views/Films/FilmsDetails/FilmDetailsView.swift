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
    let settings = MockSettingsStorageService(languageIndex: 0, shouldHideFavoritesOnMainScreen: false)

    var vm2 = FavoritesViewModel(storageService: MockFavoriteFilmsStorageService(),
                                 settingsService: settings)

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
                
                ZStack(alignment: .bottom) {
                    FilmImageView(urlPath: model.bannerImage)
                        .frame(height: 300)
                        .containerRelativeFrame(.horizontal)
                    HStack {
                        Text(model.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    
                    /// 'ultraThinMaterial' for an adaptive blur effect
                    .background(.ultraThinMaterial)
                    /// Add a mask for a progressive blur/fade effect
                    .mask(LinearGradient(gradient:
                                            Gradient(colors: [Color.white.opacity(0.7), Color.white]), startPoint: .top, endPoint: .bottom))
                }

                HStack() {
                    listOfDetailsView
                    .frame(maxHeight: .infinity)
                    
                    Spacer()
                    
                    VStack {
                        //TODO: - centering
                        Spacer()
                        Text("Score: ")

                        Text(model.score)
                            .font(.largeTitle)
                            .foregroundStyle(model.scoreInt > 50 ? .green : .orange)
                        +
                        Text(" / 100")

                    }
                    .frame(maxHeight: .infinity)
                    
                }
                .frame(height: 70)
                .padding()

                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.title3)
                
                    Divider()
                    Text(model.description)
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Characters/Cast")
                        .font(.title3)
                    
                    Divider()
                    
                    switch viewModel.state {
                    case .idle:
                        EmptyView()
                        
                    case .loaded(let people):
                        PeopleListView(models: people)
    
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
            
            .navigationTitle(model.title)
            .navigationBarTitleDisplayMode(.inline)
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
    
//MARK: - Private
    
    private var listOfDetailsView: some View {
        VStack(alignment: .leading) {
//            HStack {
//                Text(model.title)
//                    .font(.title2)
//            }
//            
//            Divider()
            Spacer()
            
            HStack {
                Text("Released on ")
                    .foregroundStyle(.gray.opacity(0.99))
                + Text(model.releaseYear)
            }
            
            HStack {
                Text("Directed by ")
                    .foregroundStyle(.gray.opacity(0.99))
                + Text(model.director)
            }
            
            HStack {
                Text("Producer: ")
                    .foregroundStyle(.gray.opacity(0.99))
                + Text(model.producer)
            }
            
            HStack {
                Text("Duration: ")
                    .foregroundStyle(.gray.opacity(0.99))
                + Text(model.duration)
                + Text(" min")
            }
        }
    }
}
