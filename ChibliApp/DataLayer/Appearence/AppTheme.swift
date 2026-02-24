//
//  AppTheme.swift
//  ChibliApp
//
//  Created by Olena Solovii on 24.02.2026.
//

import Foundation
import SwiftUI

enum AppTheme: String, CaseIterable {
    case light, dark, system

    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}
