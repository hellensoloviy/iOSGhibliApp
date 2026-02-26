//
//  SettingsStorageService.swift
//  ChibliApp
//
//  Created by Olena Solovii on 24.02.2026.
//

import Foundation

protocol SettingsStorageServiceProtocol {
    
    func saveLanguageChoice(_ lang: String)
    func getLanguageChoice() -> String?
    
    func saveShowFavoroitesOnMainScreen(_ value: Bool)
    func loadShouldShowFavoroitesOnMainScreen() -> Bool
    
    func clearAll()
}


struct SettingsStorageService: SettingsStorageServiceProtocol {
    
    func saveShowFavoroitesOnMainScreen(_ value: Bool) {
        StorageService().save(value, for: .shouldShowFavoritesOnMainScreen)
    }
    
    func loadShouldShowFavoroitesOnMainScreen() -> Bool {
        let value: Bool = StorageService().load(for: .shouldShowFavoritesOnMainScreen)
        return value
    }
    
    func saveLanguageChoice(_ lang: String) {
        StorageService().save(lang, for: .language)
    }
    
    func getLanguageChoice() -> String? {
        let lang: String? = StorageService().load(for: .language)
        return lang
    }

    
    func clearAll() {
        StorageService().remove(for: .language)
    }
    
    
}

//MARK: - Mock
class MockSettingsStorageService: SettingsStorageServiceProtocol {
    
    var languageIndex: Int
    var shouldShowFavoritesOnMainScreen: Bool
    var languageOptions: [String]

    init(languageIndex: Int = 0, languageOptions: [String] = ["English", "Ukrainian", "Arabic", "Chinese", "Danish"], shouldShowFavoritesOnMainScreen: Bool) {
        self.languageIndex = languageIndex
        self.languageOptions = languageOptions
        self.shouldShowFavoritesOnMainScreen = shouldShowFavoritesOnMainScreen
    }

    func saveLanguageChoice(_ lang: String) {
        if let index = languageOptions.firstIndex(of: lang) {
            languageIndex = index
            print("Index of \(lang) is \(index)")
        } else {
            languageIndex = 0
            print("Error: Language not found")
        }
    }

    func getLanguageChoice() -> String? {
        return languageOptions[safe: languageIndex]
    }
    
    func clearAll() {
        languageIndex = 0
    }
    
    func saveShowFavoroitesOnMainScreen(_ value: Bool) {
        shouldShowFavoritesOnMainScreen = value
    }
    
    func loadShouldShowFavoroitesOnMainScreen() -> Bool {
        return shouldShowFavoritesOnMainScreen
    }
    
    
}

