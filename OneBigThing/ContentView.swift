//
//  ContentView.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 29/04/2025.
//

import SwiftUI
import SwiftData

import ConfettiSwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var things: [Thing]
    @State private var trigger: Int = 0

    @State private var details = ""
    @State private var done = false

    private var todaysThing: Thing? {
        things.first { Calendar.current.isDateInToday($0.timestamp) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                // Big header
                Text("One Big Thing")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .multilineTextAlignment(.center) // Center text horizontally

                // Subheading
                Text("What's the focus for today? Just One Big Thing you want to get done.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                    .multilineTextAlignment(.center) // Center text horizontally

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
                        .onChange(of: details) { _ in saveThing() }
                        .strikethrough(done) // Strikethrough when done
                        .foregroundColor(done ? .gray : .primary) // Grey out if done
                }
                .padding()

                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .center) // Vertically center content
            .padding(.horizontal)
        }
        .onAppear {
            if let t = todaysThing {
                details = t.details
                done = t.done
            }
        }
        .confettiCannon(trigger: $trigger)
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
