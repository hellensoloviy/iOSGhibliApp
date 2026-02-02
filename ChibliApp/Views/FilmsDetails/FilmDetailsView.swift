//
//  FilmDetailsView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 02.02.2026.
//

import SwiftUI

#Preview {
    @Previewable @State var vm = FilmDetailsViewModel(service: MockChibliService())
    
    FilmDetailsView(viewModel: vm)
}


struct FilmDetailsView: View {
    
    @State var viewModel: FilmDetailsViewModel

    var body: some View {
        Text("Hello, Film details!")
    }
}
