//
//  NotificationService.swift
//  ChibliApp
//
//  Created by Olena Solovii on 24.02.2026.
//


import SwiftUI
import UserNotifications
import Combine

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

            // Extract only what we need on the background thread, for avoiding possible data races risks
            let isAuthorized = settings.authorizationStatus == .authorized ||
                               settings.authorizationStatus == .provisional
            
            Task { @MainActor in
                self.isAuthorized = isAuthorized
            }
        }
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        showSettingsPage = true
    }
}