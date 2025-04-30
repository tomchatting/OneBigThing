//
//  TodayView.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 29/04/2025.
//

import SwiftUI
import SwiftData

import ConfettiSwiftUI

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("lastOpenedDate") private var lastOpenedDate: String = ""
    @Query private var things: [Thing]
    @State private var trigger: Int = 0
    @State private var details = ""
    @State private var done = false

    private var todaysThing: Thing? {
        things.first { Calendar.current.isDateInToday($0.timestamp) }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Big header
                Text("One Big Thing")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                // Subheading
                Text("What's the focus for today? Just One Big Thing you want to get done.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom)

                // Main content
                HStack {
                    Button(action: {
                        done.toggle()
                        if done { trigger += 1 } // 🎉 Trigger confetti only on check
                        saveThing()
                    }) {
                        Image(systemName: done ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }

                    TextField("What's your one big thing?", text: $details)
                        .disabled(done)
                        .onChange(of: details) { _, _ in saveThing() }
                        .strikethrough(done)
                        .foregroundColor(done ? .gray : .primary)
                }
                .padding()

                Spacer()
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal)
            
            if done {
                ShareLink(
                    item: "I just did my One Big Thing! 🚀 Check out the app: https://testflight.apple.com/join/W98ywUc5",
                    label: {
                        Label("Share your achievement", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .padding()
                    }
                )
            }
        }
        .onAppear {
            let todayStr = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)

                if lastOpenedDate != todayStr {
                    lastOpenedDate = todayStr

                    if todaysThing == nil {
                        details = ""
                        done = false
                    }
                } else {
                    if let t = todaysThing {
                        details = t.details
                        done = t.done
                    }
                }
        }
        .confettiCannon(trigger: $trigger)
        .scrollDisabled(true)
    }

    private func saveThing() {
        if let thing = todaysThing {
            thing.details = details
            thing.done = done
            thing.doneTimestamp = done ? (thing.doneTimestamp ?? Date()) : nil
        } else {
            let newThing = Thing(timestamp: Date(), details: details)
            newThing.done = done
            newThing.doneTimestamp = done ? Date() : nil
            modelContext.insert(newThing)
        }
        try? modelContext.save()
        
        if done {
            NotificationHelper.cancelEveningReminder()
        }
    }
}
