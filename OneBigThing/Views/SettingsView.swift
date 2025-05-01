//
//  SettingsView.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 30/04/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("morningNotificationHour") private var morningHour: Int = 8
    @AppStorage("morningNotificationMinute") private var morningMinute: Int = 0
    @AppStorage("eveningNotificationHour") private var eveningHour: Int = 20
    @AppStorage("eveningNotificationMinute") private var eveningMinute: Int = 0
    
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var appBuild: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }

    var body: some View {
        NavigationStack {
            Group {
                Form {
                    Section(header: Text("Notification Times")) {
                        DatePicker("Morning Reminder", selection: Binding(
                            get: { time(forHour: morningHour, minute: morningMinute) },
                            set: {
                                let comps = Calendar.current.dateComponents([.hour, .minute], from: $0)
                                morningHour = comps.hour ?? 8
                                morningMinute = comps.minute ?? 0
                                schedule()
                            }
                        ), displayedComponents: .hourAndMinute)
                        
                        DatePicker("Evening Reminder", selection: Binding(
                            get: { time(forHour: eveningHour, minute: eveningMinute) },
                            set: {
                                let comps = Calendar.current.dateComponents([.hour, .minute], from: $0)
                                eveningHour = comps.hour ?? 20
                                eveningMinute = comps.minute ?? 0
                                schedule()
                            }
                        ), displayedComponents: .hourAndMinute)
                    }
                    Section(header: Text("About One Big Thing")) {
                        Text("Version: \(appVersion) (\(appBuild))")
                        Text("© 2025 Thomas Chatting")
                    }
                }
                .navigationTitle("Settings")
            }
        }
    }

    private func time(forHour hour: Int, minute: Int) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
    }

    private func schedule() {
        NotificationHelper.scheduleDailyReminders(
            morningHour: morningHour,
            morningMinute: morningMinute,
            eveningHour: eveningHour,
            eveningMinute: eveningMinute
        )
    }
}
