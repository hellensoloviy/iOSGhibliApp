//
//  FavoritesViewModel.swift
//  ChibliApp
//
//  Created by Olena Solovii on 04.02.2026.
//

import Foundation
import Observation

@Observable
class FavoritesViewModel {
    
    private let storageService: FavoriteFilmsStorageProtocol
    private let settingsService: SettingsStorageServiceProtocol

    private(set) var favoriteIDs: Set<String> = []
    
    
    init(storageService: FavoriteFilmsStorageProtocol, settingsService: SettingsStorageServiceProtocol) {
        self.storageService = storageService
        self.settingsService = settingsService
    }
    
//MARK: -
    func shouldHideFavoritesOnMainList() -> Bool {
        return settingsService.loadShouldHideFavoroitesOnMainScreen()
    }
    
    func isFavorite(filmID: String) -> Bool {
        return favoriteIDs.contains(filmID)
    }
    
    func toggleFavorite(filmID: String) {
        if favoriteIDs.contains(filmID) {
            favoriteIDs.remove(filmID)
        } else {
            favoriteIDs.insert(filmID)
        }
        
        save()
    }
    
//MARK: - Storing
    func save() {
        storageService.save(favoriteIDs)
    }
    
    func load() {
        favoriteIDs = storageService.load()
    }
    
}
