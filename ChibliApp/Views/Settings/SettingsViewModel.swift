//
//  SettingsViewModel.swift
//  ChibliApp
//
//  Created by Olena Solovii on 19.02.2026.
//

import Foundation
import Observation

@Observable
class SettingsViewModel {
    
    var languageOptions = ["English", "Ukrainian", "Arabic", "Chinese", "Danish"]
    
    //MARK: -
    
    private let storageService: FavoriteFilmsStorageProtocol
    private let settingsService: SettingsStorageServiceProtocol
    
    
    init(storageService: FavoriteFilmsStorageProtocol, settingsService: SettingsStorageServiceProtocol) {
        self.storageService = storageService
        self.settingsService = settingsService
        
    }
    
//MARK: -

    func updateLanguage(to language: String) {
        settingsService.saveLanguageChoice(language)
    }
    
    func restoreLanguageChoiceIndex() -> Int {
        guard let languageString = settingsService.getLanguageChoice() else {
            return 0
        }
        
        if let index = languageOptions.firstIndex(of: languageString) {
            return index
        } else {
            print("🔴 Error: Language not found, the first one will be selected")
            return 0
        }
        
    }
        
//MARK: - Storing


    
//MARK: - Clear data
    
    func resetToDefaults() {
        clearFavorites()
        
        settingsService.clearAll()
    }
    
    private func clearFavorites() {
        storageService.clearAll()
    }

}
