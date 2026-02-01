//
//  FilmListView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 01.02.2026.
//

import SwiftUI

struct FilmListView: View {
    
    @State private var viewModel = FilmsViewModel()
    
    var films: [Film] = []
    
    var body: some View {
        
        switch viewModel.state {
        case .loaded(let models):
            List(models) { obj in
                Text(obj.title)
            }
        case .loading:
            ProgressView {
                Text("Loadig the list...")
            }
        case .error(let error):
            Text("Error! \(error.description)")
                .foregroundStyle(.pink)
            
        case .empty:
            ContentUnavailableView {
                Label("Nothing to show", systemImage: "list.bullet.rectangle.portrait")
            } description: {
                Text("The list if empty")
            } actions: {
                /// nothing here for now
            }
            .offset(y: -60)
        
        case .idle:
            Text("Nothing here yet.")
                .task {
                   await viewModel.fetch()
               }

        }

//        .overlay {
//            viewModel.state == FilmsViewModel.State.empty {
//                ContentUnavailableView {
//                    Label("Nothing to show", systemImage: "list.bullet.rectangle.portrait")
//                } description: {
//                    Text("The list if empty")
//                } actions: {
//                    /// nothing here for now
//                }
//                .offset(y: -60)
//            }
//        }
        
    }
}

#Preview {
    FilmListView()
}
