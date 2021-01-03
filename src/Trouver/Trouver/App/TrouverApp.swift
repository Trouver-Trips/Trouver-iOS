//
//  TrouverApp.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/19/20.
//

import SwiftUI
import GoogleSignIn

@main
struct TrouverApp: App {
    //swiftlint:disable weak_delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //swiftlint:enable weak_delegate

    var body: some Scene {
        WindowGroup {
            SignInView()
                .environmentObject(appDelegate.viewModel)
        }
    }
}
