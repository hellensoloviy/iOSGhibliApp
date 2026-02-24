//
//  AppTheme.swift
//  ChibliApp
//
//  Created by Olena Solovii on 24.02.2026.
//

import Foundation
import SwiftUI


struct ThemeSwitcher<Content: View>: View {
    @ViewBuilder var content: Content
    @AppStorage("app_theme") private var appTheme: AppTheme = .system // Default to system
    
    var body: some View {
        content
            .preferredColorScheme(appTheme.colorScheme)
    }
}

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
