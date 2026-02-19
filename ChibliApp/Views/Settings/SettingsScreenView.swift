//
//  SettingsScreenView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 04.02.2026.
//

import SwiftUI

#Preview {
    SettingsScreenView(viewModel:
                        SettingsViewModel(storageService: MockFavoriteFilmsStorageService())
    )
}

struct SettingsScreenView: View {
    
    @State private var isLightThemeOn: Bool = false
    @State private var shouldShowFavoritesUIOnTheMainList: Bool = false
    @State private var isNotificationsEnabled: Bool = false
    
    @State private var languageIndex = 0
    var languageOptions = ["English", "Arabic", "Chinese", "Danish"]
    
    let viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    Section("Appearence") {
                        HStack {
                            Text("Light mode only")
                            Spacer()
                            Toggle(isOn: $isLightThemeOn) {
                                /// action here
                            }
                        }
                        
                        HStack {
                            Text("Show favorites UI in the main list")
                            Spacer()
                            Toggle(isOn: $shouldShowFavoritesUIOnTheMainList) {
                                /// action here
                            }
                        }
                        
                    }
                }
                
                Group {
                    Section("Preferences") {
                        HStack {
                            Text("Enable notification")
                            Spacer()
                            Toggle(isOn: $isNotificationsEnabled) {
                                /// action here
                            }
                        }
                        
                        Picker(selection: $languageIndex,
                               label: Text("Language")) {
                            ForEach(0 ..< languageOptions.count) {
                                Text(self.languageOptions[$0])
                            }
                        }
                    }
                }
                
                Button {
                    /// action here 
                } label: {
                    Text("Reset to defaults")
                        .foregroundStyle(.red)
                }
                .accessibilityHint("Reset to defaults button")
                
            }
            .navigationTitle("Settings")

        }

    }
}


