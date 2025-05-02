//
//  AppEnvironmentHelper.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 02/05/2025.
//

import Foundation

enum AppEnvironmentHelper {
    static var isTestFlight: Bool {
        Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }

    static var shareURL: URL {
        URL(string: isTestFlight
            ? "https://testflight.apple.com/join/W98ywUc5"
            : "https://apps.apple.com/gb/app/one-big-thing/id6745229950"
        )!
    }

    static var shareMessage: String {
        "I just completed my One Big Thing for the day! 🚀 \(isTestFlight ? "Try the beta" : "Download the app"): \(shareURL)"
    }
}
