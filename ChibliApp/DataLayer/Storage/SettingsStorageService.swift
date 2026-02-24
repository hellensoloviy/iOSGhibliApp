//
//  SettingsStorageService.swift
//  ChibliApp
//
//  Created by Olena Solovii on 24.02.2026.
//

import Foundation

protocol SettingsStorageServiceProtocol {
    func saveUseLightTheme(newValue: Bool)
    func getIsLightThemeOn() -> Bool
    
    func saveLanguageChoice(_ lang: String)
    func getLanguageChoice() -> String?
    
    func clearAll()
}


struct SettingsStorageService: SettingsStorageServiceProtocol {
    
    func saveLanguageChoice(_ lang: String) {
        StorageService().save(lang, for: .language)
    }
    
    func getLanguageChoice() -> String? {
        let lang: String? = StorageService().load(for: .language)
        return lang
    }
    
    func saveUseLightTheme(newValue: Bool) {
        StorageService().save(newValue, for: .useLightTheme)
    }
    
    func getIsLightThemeOn() -> Bool {
        let isOn: Bool = StorageService().load(for: .useLightTheme)
        return isOn
    }
    
    func clearAll() {
        StorageService().remove(for: .useLightTheme)
        StorageService().remove(for: .language)
    }
    
    
}

//MARK: - Mock
class MockSettingsStorageService: SettingsStorageServiceProtocol {
    
    var isLightThemeOn: Bool
    var languageIndex: Int
    var languageOptions: [String]

    init(isLightThemeOn: Bool = false, languageIndex: Int = 0, languageOptions: [String] = ["English", "Ukrainian", "Arabic", "Chinese", "Danish"]) {
        self.isLightThemeOn = isLightThemeOn
        self.languageIndex = languageIndex
        self.languageOptions = languageOptions
    }
    
    func saveUseLightTheme(newValue: Bool) {
        self.isLightThemeOn = newValue
    }
    
    func getIsLightThemeOn() -> Bool {
        return isLightThemeOn
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
        isLightThemeOn = false
    }
    
    
}

