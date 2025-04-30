//
//  NotificationHelper.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 29/04/2025.
//

import Foundation
import UserNotifications
import SwiftUI

enum NotificationHelper {
    static func requestPermissionAndSchedule() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                scheduleDailyReminders()
            }
        }
    }

    static func scheduleDailyReminders(
        morningHour: Int = 8,
        morningMinute: Int = 0,
        eveningHour: Int = 21,
        eveningMinute: Int = 0
    ) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["morning-reminder", "evening-checkin"])

        let morningTrigger = calendarTrigger(hour: morningHour, minute: morningMinute)
        let eveningTrigger = calendarTrigger(hour: eveningHour, minute: eveningMinute)

        let morningContent = UNMutableNotificationContent()
        morningContent.title = "What's your One Big Thing today?"
        morningContent.body = "Set your goal for the day."

        let eveningContent = UNMutableNotificationContent()
        eveningContent.title = "Did you finish your One Big Thing?"
        eveningContent.body = "Mark it complete if you haven't already."

        center.add(UNNotificationRequest(identifier: "morning-reminder", content: morningContent, trigger: morningTrigger))
        center.add(UNNotificationRequest(identifier: "evening-checkin", content: eveningContent, trigger: eveningTrigger))
    }


    private static func calendarTrigger(hour: Int, minute: Int) -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    }


    static func cancelEveningReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["evening-checkin"])
    }
}
