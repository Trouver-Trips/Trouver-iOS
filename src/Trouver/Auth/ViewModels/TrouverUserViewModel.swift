//
//  TrouverUserViewModel.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import Foundation
import GoogleSignIn

class TrouverUserViewModel: NSObject, ObservableObject {
    @Published private var user: TrouverUser?
    @Published var signedIn: Bool = false

    // Access to model

    var name: String { user?.fullName ?? "Guest User" }
    var email: String { user?.email ?? "example@gmail.com" }

    // Intents

    func silentSignIn() {
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    func logOut() {
        if let user = self.user {
            switch user.accountType {
            case .google:
                GIDSignIn.sharedInstance().signOut()
            case .guest: break
            }
        }
        self.user = nil
        self.signedIn = false
    }
}

// Google
extension TrouverUserViewModel: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error as NSError? {
            if error.code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                Logger.logInfo("The user has not signed in before or they have since signed out.")
            } else if error.code == GIDSignInErrorCode.canceled.rawValue {
                Logger.logInfo("Google Sign In cancelled")
            } else {
                Logger.logError("Google Sign In errored", error: error)
            }
            return
        }

        // If the previous `error` is null, then the sign-in was succesful
        Logger.logInfo("Successful sign-in!")
        self.signedIn = true
        self.signInGoogleUser(googleUser: user)
        //Logger.logInfo(user.authentication.idToken ?? "No token") // Safe to send to the server
    }

    private func signInGoogleUser(googleUser: GIDGoogleUser) {
        if let profile = googleUser.profile {
            self.user = TrouverUser(userId: googleUser.userID,
                                    fullName: profile.name,
                                    givenName: profile.givenName,
                                    familyName: profile.familyName,
                                    email: profile.email,
                                    accountType: .google,
                                    tokenRefresher: GoogleTokenRefresher(googleUser: googleUser))
        }
    }
}
