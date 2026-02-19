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
    
    private let storageService: FavoriteFilmsStorageProtocol
    
    init(storageService: FavoriteFilmsStorageProtocol) {
        self.storageService = storageService
    }
    
//MARK: -

    
//MARK: - Clear data
    
    func resetToDefaults() {
        clearFavorites()

        /// here goes a list of other actions needed to be reset
    }
    
    private func clearFavorites() {
        storageService.clearAll()
    }

}
