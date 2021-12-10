//
//  AppDelegate.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import UIKit
import GoogleSignIn
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    private(set) var viewModel: LoginService!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)
    -> Bool {
        // Initialize sign-in
        self.viewModel = LoginService()
        self.viewModel.silentSignIn()
        
        // Initialize Places
        
        GMSPlacesClient.provideAPIKey(PlistReader.read(key: "GOOGLE_API_KEY") ?? "Invalid key")
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
