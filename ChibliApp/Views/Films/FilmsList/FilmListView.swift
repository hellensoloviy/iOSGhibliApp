//
//  FilmListView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 01.02.2026.
//

import SwiftUI

#Preview {
    @Previewable @State var vm = FilmsViewModel(service: MockChibliService())
    
    FilmListView(viewModel: vm)
}


struct FilmListView: View {
    
    @State var viewModel: FilmsViewModel
    
    var films: [Film] = []
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                Text("Nothing here yet.")
                
            case .loaded(let models):
                List(models) { obj in
                    NavigationLink(value: obj) {
                        HStack {
                            //TODO: - fix placeholder loading frame to be equal 
                            FilmImageView(urlPath: obj.image)
                                .frame(width: 100, height: 150)
                            Text(obj.title)
                        }
                    }
                }
                .navigationTitle("Fims")
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: Film.self) { obj in
                    FilmDetailsView(model: obj)
                }
                
            case .loading:
                    //TODO: - add effect here
                ProgressView {
                    Text("Loadig the list...")
                }
            case .error(let error):
                Text("Error! \(error.description)")
                    .foregroundStyle(.pink)
                
            case .empty:
                ContentUnavailableView {
                    Label("Nothing to show", systemImage: "moon.dust")
                } description: {
                    Text("The list is empty")
                } actions: {
                    /// nothing here for now
                }
                .offset(y: -60)

            }
        }
        .task {
            await viewModel.fetch()
        }
        
    }
}

