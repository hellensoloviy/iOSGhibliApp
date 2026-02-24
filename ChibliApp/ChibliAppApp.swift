//
//  ChibliAppApp.swift
//  ChibliApp
//
//  Created by Hellen Soloviy on 01.02.2026.
//

import SwiftUI

@main
struct ChibliAppApp: App {
    
    @AppStorage("app_theme") private var appTheme: AppTheme = .system // Default to system
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                filmsViewModel: FilmsViewModel(),
                favoritesViewModel: FavoritesViewModel(storageService: FavoriteFilmsStorageService())
            )
            .preferredColorScheme(appTheme.colorScheme)
        }
    }
}
