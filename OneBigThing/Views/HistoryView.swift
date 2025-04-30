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

    var body: some View {
        NavigationStack {
            if things.isEmpty {
                Text("No history yet")
            }
            
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
            }
            .navigationTitle("History")
        }
    }
}
