//
//  OnboardingView.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 30/04/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var page = 0
    var onFinish: () -> Void

    private let pages = [
        OnboardingPage(title: "Welcome to One Big Thing", description: "Start each day with clarity by choosing your one big thing.", icon: "checkmark.seal"),
        OnboardingPage(title: "Stay Focused", description: "Focus on just completing one thing.", icon: "brain.head.profile.fill"),
        OnboardingPage(title: "Track Progress", description: "Review your past days and see how you’re doing.", icon: "fossil.shell")
    ]

    var body: some View {
        TabView(selection: $page) {
            ForEach(pages.indices, id: \.self) { i in
                VStack(spacing: 30) {
                    Spacer()

                    Image(systemName: pages[i].icon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .foregroundStyle(.secondary)

                    Text(pages[i].title)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)

                    Text(pages[i].description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    if i == pages.count - 1 {
                        Button("Get Started") {
                            onFinish()
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    Spacer()
                }
                .padding()
                .tag(i)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
}
