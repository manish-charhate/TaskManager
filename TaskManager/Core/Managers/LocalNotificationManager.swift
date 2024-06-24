//
//  LocalNotificationManager.swift
//  TaskManager
//
//  Created by Manish Charhate on 23/06/24.
//

import Foundation
import UserNotifications

final class LocalNotificationManager {
    
    // MARK: Properties
    
    private let notificationCenter: UNUserNotificationCenter
    
    // MARK: Init
    
    init(notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()) {
        self.notificationCenter = notificationCenter
    }
    
    // MARK: Public methods
    
    func requestNotificationPermission() async {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                print("Permission granted")
                // You can now schedule notifications
            } else {
                print("Permission denied")
                // Handle the case where permission was denied
            }
        } catch {
            print("Request authorization failed: \(error.localizedDescription)")
        }
    }
    
    func scheduleLocalNotificationWith(
        id: String,
        title: String,
        on date: Date
    ) async throws {
        let setting = await notificationCenter.notificationSettings()
        guard setting.authorizationStatus == .authorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Following task is due today:"
        content.body = title
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
        dateComponents.hour = 9
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )
        
        let notificationRequest = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        try await notificationCenter.add(notificationRequest)
    }
    
    func removePendingNotification(for id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
}
