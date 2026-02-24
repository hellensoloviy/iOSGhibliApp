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
    SettingsScreenView(viewModel:
                        SettingsViewModel(storageService: MockFavoriteFilmsStorageService())
    )
}

struct SettingsScreenView: View {
    
    @StateObject var notificationService = NotificationService()
    
    @State private var isLightThemeOn: Bool = false
    @State private var shouldShowFavoritesUIOnTheMainList: Bool = false
    
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
                            Toggle("Enable notifications", isOn: $notificationService.isAuthorized)
                                .onChange(of: notificationService.isAuthorized) { _, newValue in
                                    if newValue {
                                        Task {
                                            await notificationService.requestPermission()
                                        }
                                    } else {
                                        notificationService.showSettingsPage = true
                                    }
                                }

                        }
                        
                        Picker(selection: $languageIndex,
                               label: Text("Language")) {
                            ForEach(0 ..< languageOptions.count) {
                                Text(self.languageOptions[$0])
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $notificationService.showSettingsPage, content: {
                        // your settings page here
                        VStack {
                            Text("Settings Page").font(.title)
                            Text("All your settings here").font(.subheadline)
                            Button("Dismiss") {
                                notificationService.showSettingsPage = false
                            }
                            .padding()
                            .buttonStyle(.borderedProminent)
                        }
                    })
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
        .onAppear {
            notificationService.refreshAuthorizationStatus()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.willEnterForegroundNotification
            )
        ) { _ in
            notificationService.refreshAuthorizationStatus()
        }
        

    }
}

final class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    @Published var showSettingsPage = false
    @Published var badgeNumber = 0
    @Published var isAuthorized = false

    
    var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        
        $badgeNumber
            .drop(while: {$0 < 1})
            .sink { badgeNumber in
            UIApplication.shared.applicationIconBadgeNumber = badgeNumber
        }.store(in: &cancellables)
    }
    
    func requestPushNotificationAuthorization() async {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [
                    .alert,
                    .sound,
                    .badge])

            await MainActor.run {
                if !granted {
                    self.showSettingsPage = true
                }
                
                self.isAuthorized = granted
            }
            
            refreshAuthorizationStatus()

        } catch {
            print(error)
        }
    }
    
    func refreshAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard let self else { return }

            Task {
                await MainActor.run {
                    self.isAuthorized =
                        settings.authorizationStatus == .authorized ||
                        settings.authorizationStatus == .provisional
                }
            }
        }
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        showSettingsPage = true
    }
}



