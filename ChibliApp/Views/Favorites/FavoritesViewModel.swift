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
    private(set) var favoriteIDs: Set<String> = []
    
    
    init(storageService: FavoriteFilmsStorageProtocol) {
        self.storageService = storageService
    }
    
//MARK: -
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
