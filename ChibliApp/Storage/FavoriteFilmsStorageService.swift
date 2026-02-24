//
//  FavoriteFilmsStorageService.swift
//  ChibliApp
//
//  Created by Olena Solovii on 04.02.2026.
//

import Foundation

protocol FavoriteFilmsStorageProtocol {
    func save(_ object: Set<String>)
    func load() -> Set<String>
    func clearAll()
}

struct FavoriteFilmsStorageService: FavoriteFilmsStorageProtocol {
    
    func save(_ object: Set<String>) {
        StorageService().save(Array(object), for: .favoriteFilms)
    }
    
    func load() -> Set<String> {
        let array = StorageService().loadArray(for: .favoriteFilms)
        let favoriteIDs = Set(array)
        return favoriteIDs
    }
    
    func clearAll() {
        StorageService().remove(for: .favoriteFilms)
    }
    
}

//MARK: - Mock

struct MockFavoriteFilmsStorageService: FavoriteFilmsStorageProtocol {
    func clearAll() {
        /* nothing needed */
    }
    
    func save(_ object: Set<String>) { /* nothing neeeded */}
    
    func load() -> Set<String> {
        return ["58611129-2dbc-4a81-a72f-77ddfc1b1b49", "12cfb892-aac0-4c5b-94af-521852e46d6a"]
    }
    
}

