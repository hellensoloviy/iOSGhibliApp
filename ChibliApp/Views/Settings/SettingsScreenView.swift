//
//  SettingsScreenView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 04.02.2026.
//

import SwiftUI
import UserNotifications
import Combine

#Preview {
    let settings = MockSettingsStorageService(languageIndex: 0, shouldHideFavoritesOnMainScreen: false)
    
    SettingsScreenView(
        viewModel: SettingsViewModel(storageService: MockFavoriteFilmsStorageService(),
                                    settingsService: settings)
    )
}

struct SettingsScreenView: View {
    @AppStorage("app_theme") private var appTheme: AppTheme = .system

    @StateObject var notificationService = NotificationService()
    
    @State private var shouldHideFavoritesUIOnTheMainList: Bool = false
    
    @State private var languageIndex = 0
    /// test options here
    
    let viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Appearence") {
                    appearenceThemePickerView
                    showFavoritesToggleView
                }
                
                Section("Preferences") {
                    enableNotificationToggle
                    
                    Picker(selection: $languageIndex,
                           label: Text("Language")) {
                        let count = viewModel.languageOptions.count
                        ForEach(0..<count, id: \.self) { index in
                            Text(viewModel.languageOptions[index])
                        }
                    }
                   .onChange(of: languageIndex) { _, newValue in
                       print("Selected language: \(viewModel.languageOptions[newValue])")
                       viewModel.updateLanguage(to: viewModel.languageOptions[newValue])
                   }
                    
                }
                
                Button {
                    viewModel.resetToDefaults()
                } label: {
                    Text("Reset to defaults")
                        .foregroundStyle(.red)
                }
                .accessibilityHint("Reset to defaults button")
                
            }
            .navigationTitle("Settings")

        }
        .onAppear {
            shouldHideFavoritesUIOnTheMainList = viewModel.shouldHideFavoritesOnMainScreen
            notificationService.refreshAuthorizationStatus()
            languageIndex = viewModel.restoreLanguageChoiceIndex()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.willEnterForegroundNotification
            )
        ) { _ in
            notificationService.refreshAuthorizationStatus()
        }
        
    }
    
//MARK: - Private UI
    
    private var appearenceThemePickerView: some View {
        Picker("Appearance", selection: $appTheme) {
            ForEach(AppTheme.allCases, id: \.self) { theme in
                Text(theme.rawValue.capitalized).tag(theme)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private var showFavoritesToggleView: some View {
        HStack {
            Spacer()
            Toggle(isOn: $shouldHideFavoritesUIOnTheMainList) {
                Text("Hide favorites UI from the films list")
            }
            .onChange(of: shouldHideFavoritesUIOnTheMainList) {
                viewModel.saveshouldHideFavoritesOnMainScreen()
            }
        }
    }
    
    private var enableNotificationToggle: some View {
        HStack {
            Toggle("Enable notifications", isOn: $notificationService.isAuthorized)
                .onChange(of: notificationService.isAuthorized) { _, newValue in
                    if newValue {
                        Task {
                            await notificationService.requestPushNotificationAuthorization()
                        }
                    } else {
                        notificationService.showSettingsPage = true
                    }
                }

        }
    }

//MARK: - Private Logic

    
}






