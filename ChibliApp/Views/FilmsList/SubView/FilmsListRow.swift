//
//  FilmsListRow.swift
//  ChibliApp
//
//  Created by Olena Solovii on 02.02.2026.
//

import SwiftUI

struct FilmsListRow: View {
    
    let model: Film
    
    var body: some View {
        Text(model.title)
    }
    
}

#Preview {
    
    let service = MockChibliService()
    let film = service.fetchFilm()
    
    FilmsListRow(model: film)

}
