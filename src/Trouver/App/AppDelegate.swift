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
    let viewModel = LoginService()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)
    -> Bool {
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "14106003132-6e5p3gnulc32uall0qn9hdumh1jpvgbf.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = viewModel
        viewModel.silentSignIn()
        
        // Initialize Places
        
        GMSPlacesClient.provideAPIKey(PlistReader.read(key: "GOOGLE_API_KEY") ?? "Invalid key")
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}
