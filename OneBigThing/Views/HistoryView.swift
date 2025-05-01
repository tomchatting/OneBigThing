//
//  HistoryView.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 30/04/2025.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query private var things: [Thing]
    @Environment(\.modelContext) private var modelContext
    @State private var showDeleteAllConfirm = false

    var body: some View {
        NavigationStack {
            Group {
                if things.isEmpty {
                    VStack {
                        Spacer()
                        Text("No history yet")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(things.sorted(by: { $0.timestamp > $1.timestamp })) { thing in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(thing.details)
                                        .strikethrough(thing.done)
                                        .foregroundColor(thing.done ? .gray : .primary)
                                    Text(thing.timestamp, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if thing.done {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                if !things.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(role: .destructive) {
                            showDeleteAllConfirm = true
                        } label: {
                            Label("Delete All", systemImage: "trash")
                        }
                    }
                }
            }
            .alert("Delete all history?", isPresented: $showDeleteAllConfirm) {
                Button("Delete All", role: .destructive, action: deleteAll)
                Button("Cancel", role: .cancel) { }
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(things[index])
        }
    }

    private func deleteAll() {
        for thing in things {
            modelContext.delete(thing)
        }
    }
}
