//
//  ContentView.swift
//  ChibliApp
//
//  Created by Hellen Soloviy on 01.02.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Movies", systemImage: "movieclapper") {
                FilmsScreenView()
            }
            Tab("Favorites", systemImage: "heart") {
                FavoritesScreenView()
            }
            Tab("Settigs", systemImage: "gear") {
                SettingsScreenView()
            }
            
            Tab(role: .search) {
                SearchScreenView()
            }
        } 
    }
}

#Preview {
    ContentView()
}
