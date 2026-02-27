//
//  PeopleListView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 27.02.2026.
//

import SwiftUI

struct PeopleListView: View {
    
    var models: [Person]
    
    var body: some View {
        List(models) { model in
            Text(model.name)
        }
        .overlay {
            if models.isEmpty {
                ContentUnavailableView {
                    Label("Cast list if empty", systemImage: "moon.dust")
                } description: {
                    Text("Nothing is found")
                } actions: {
                    /// nothing here for now
                }
                .offset(y: -60)
            }
        }
    }
}

#Preview {
    
    let service = MockChibliService()
    let peopleList = service.fetchPersonDetailsList()
    
    PeopleListView(models: peopleList)
    
}
