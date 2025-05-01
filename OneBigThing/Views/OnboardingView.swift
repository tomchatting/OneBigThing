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
        OnboardingPage(title: "Welcome to One Big Thing", description: "Start each day with clarity by choosing your one big thing."),
        OnboardingPage(title: "Stay Focused", description: "Keep your goal in front of you — right on your Home Screen."),
        OnboardingPage(title: "Track Progress", description: "Review your past days and see how you’re doing.")
    ]

    var body: some View {
        TabView(selection: $page) {
            ForEach(pages.indices, id: \.self) { i in
                VStack(spacing: 30) {
                    Spacer()

                    Image(systemName: "checkmark.seal")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .foregroundStyle(.accent)

                    Text(pages[i].title)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)

                    Text(pages[i].description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Spacer()

                    if i == pages.count - 1 {
                        Button("Get Started") {
                            onFinish()
                        }
                        .buttonStyle(.borderedProminent)
                    }
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
}
