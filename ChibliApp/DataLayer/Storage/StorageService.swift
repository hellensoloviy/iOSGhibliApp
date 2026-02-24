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
        case useLightTheme = "ChibliApp.hellensoloviy.test.app.use.light.theme.only"
        case language = "ChibliApp.hellensoloviy.test.app.use.use.selected.language"

    }
    
//MARK: -
    func save(_ object: Any, for key: StorageService.CustomKeys) {
        UserDefaults.standard.set(object, forKey: key.rawValue)

    }
    
    func load(for key: StorageService.CustomKeys) -> String? {
        let value = UserDefaults.standard.string(forKey: key.rawValue)
        return value
    }
    
    func load(for key: StorageService.CustomKeys) -> Bool {
        let value = UserDefaults.standard.bool(forKey: key.rawValue)
        return value
    }
    
    func load(for key: StorageService.CustomKeys) -> Any? {
        let obj = UserDefaults.standard.object(forKey: key.rawValue) ?? nil
        return obj
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
