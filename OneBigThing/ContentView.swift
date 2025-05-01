//
//  ContentView.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 29/04/2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore = false

    var body: some View {
        if hasLaunchedBefore {
            mainTabView
        } else {
            OnboardingView {
                hasLaunchedBefore = true
            }
        }
    }

    private var mainTabView: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "checkmark.square")
                }
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
