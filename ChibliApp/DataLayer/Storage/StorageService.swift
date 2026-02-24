//
//  StorageService.swift
//  ChibliApp
//
//  Created by Olena Solovii on 04.02.2026.
//

import Foundation

struct StorageService {
    
    enum CustomKeys: String  {
        case favoriteFilms = "ChibliApp.hellensoloviy.test.app.favorite.films"
    }
    
//MARK: -
    func save(_ object: Any, for key: StorageService.CustomKeys) {
        UserDefaults.standard.set(object, forKey: key.rawValue)

    }
    
    func loadArray(for key: StorageService.CustomKeys) -> [String] {
        let array = UserDefaults.standard.stringArray(forKey: key.rawValue) ?? []
        return array
    }
    
    func remove( for key: StorageService.CustomKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)

    }
    
    func resetAll() {
        //TODO: -
    }
    
}
