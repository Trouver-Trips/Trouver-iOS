//
//  TrouverUserViewModel.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import Foundation
import GoogleSignIn

enum SignInState {
    case notSignedIn
    case tryingSilentSignIn
    case signedIn
}

class TrouverUserViewModel: NSObject, ObservableObject {
    @Published private var user: TrouverUser?
    @Published var signInState: SignInState = .notSignedIn

    // Access to model

    var name: String { user?.fullName ?? "Guest User" }
    var email: String { user?.email ?? "example@gmail.com" }

    // Intents

    func silentSignIn() {
        // Automatically sign in the user.
        self.signInState = .tryingSilentSignIn
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
        self.signInState = .notSignedIn
    }
}

// Google
extension TrouverUserViewModel: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error as NSError? {
            self.signInState = .notSignedIn
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
        self.signInState = .signedIn
        self.signInGoogleUser(googleUser: user)
    }

    private func signInGoogleUser(googleUser: GIDGoogleUser) {
        if let profile = googleUser.profile {

            self.user = TrouverUser(userId: googleUser.userID,
                                    fullName: profile.name,
                                    givenName: profile.givenName,
                                    familyName: profile.familyName,
                                    email: profile.email,
                                    accountType: .google,
                                    accessToken: googleUser.authentication.idToken,
                                    tokenRefresher: GoogleTokenRefresher(googleUser: googleUser))
        }
    }
}
