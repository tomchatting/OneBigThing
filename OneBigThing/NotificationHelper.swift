//
//  NotificationHelper.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 29/04/2025.
//

import Foundation
import UserNotifications

enum NotificationHelper {
    static func requestPermissionAndSchedule() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                scheduleDailyReminders()
            }
        }
    }

    static func scheduleDailyReminders() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["morning-reminder", "evening-checkin"])

        let morningTrigger = calendarTrigger(hour: 8)
        let eveningTrigger = calendarTrigger(hour: 21)

        let morningContent = UNMutableNotificationContent()
        morningContent.title = "What's your One Big Thing today?"
        morningContent.body = "Set your goal for the day."

        let eveningContent = UNMutableNotificationContent()
        eveningContent.title = "Did you finish your One Big Thing?"
        eveningContent.body = "Mark it complete if you haven't already."

        center.add(UNNotificationRequest(identifier: "morning-reminder", content: morningContent, trigger: morningTrigger))
        center.add(UNNotificationRequest(identifier: "evening-checkin", content: eveningContent, trigger: eveningTrigger))
    }

    private static func calendarTrigger(hour: Int) -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    }
    
    static func cancelEveningReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["evening-checkin"])
    }

}
