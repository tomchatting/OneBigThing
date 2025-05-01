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
    
    @State private var todaysThing: Thing?
    
    var body: some View {
        NavigationStack {
            Group {
                ScrollView {
                    Spacer()
                    HStack {
                        Button(action: {
                            done.toggle()
                            if done && !UIAccessibility.isReduceMotionEnabled { trigger += 1 } // 🎉 Trigger confetti only on check
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
                    
                    if done, let time = todaysThing?.doneTimestamp {
                        Text("You completed your One Big Thing at \(DateFormatter.localizedString(from: time, dateStyle: .none, timeStyle: .short)) 🎉")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Think about one thing you want to get done today 📅. Set yourself a single goal and we'll check in later to see how you got on, or you can come back any time and mark it off as complete ✅.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom)
                    }
                    
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
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .padding(.horizontal)
            }
            .onAppear {
                let today = Calendar.current.startOfDay(for: Date())
                todaysThing = things.first { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }
                
                if let thing = todaysThing {
                    details = thing.details
                    done = thing.done
                } else {
                    details = ""
                    done = false
                }
                
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
            .navigationTitle("One Big Thing")
        }
        
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
            todaysThing = newThing
        }
        try? modelContext.save()

        if done {
            NotificationHelper.cancelEveningReminder()
        }
    }

}
