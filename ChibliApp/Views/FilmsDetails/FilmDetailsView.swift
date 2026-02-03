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
    
    FilmDetailsView(model: film)
}


struct FilmDetailsView: View {
    
    @State var viewModel: FilmDetailsViewModel = FilmDetailsViewModel()
    
    var model: Film

    var body: some View {
        
        VStack(alignment: .leading) {

            
//            VStack {
//                
//            }
//            .navigationTitle(model.title)
//            .navigationBarTitleDisplayMode(.large)
            
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

            case .loading:
                ProgressView {
                    Text("Loadig the details...")
                }
            case .error(let error):
                Text("Error! \(error.description)")
                    .foregroundStyle(.pink)
                
            case .empty:
                ContentUnavailableView {
                    Label("Nothing to show", systemImage: "moon.dust")
                } description: {
                    Text("The details are empty")
                } actions: {
                    /// nothing here for now
                }
                .offset(y: -60)

            }
            
            
        }
        .padding()
        /// If we add here task(id: model) with model inside it will update the task when the model is changed;
        /// Now we do not track any changes here so we can leave it just task {}
        /// when we search for example, this can lessen the times it runs
        .task {
            await viewModel.fetch(for: model)
        }
        
    }
}
