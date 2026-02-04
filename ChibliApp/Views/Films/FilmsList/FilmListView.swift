//
//  FilmListView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 01.02.2026.
//

import SwiftUI

#Preview {
    @Previewable @State var vm = FilmsViewModel(service: MockChibliService())
    
    FilmListView(models: vm.models)
}


struct FilmListView: View {
        
    var models: [Film] = []
    
    var body: some View {
        
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
        .navigationDestination(for: Film.self) { obj in
            FilmDetailsView(model: obj)
        }
        
    }
}

