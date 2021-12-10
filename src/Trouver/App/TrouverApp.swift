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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            SignInView()
                .environmentObject(appDelegate.viewModel)
                .onAppear {
                    clearNavBarStyle()
                }
        }
    }
    
    private func clearNavBarStyle() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}
