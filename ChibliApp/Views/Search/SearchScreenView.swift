//
//  SearchScreenView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 04.02.2026.
//

import SwiftUI

struct SearchScreenView: View {
    
    @State private var textToSearch: String = ""
    
    var body: some View {
        NavigationStack {
            Text("Search here")
                .searchable(text: $textToSearch)
        }
    }
}

#Preview {
    SearchScreenView()
}
