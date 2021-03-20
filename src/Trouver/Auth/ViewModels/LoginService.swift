//
//  LoginService.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import Combine
import GoogleSignIn

enum SignInState {
    case notSignedIn
    case tryingSilentSignIn
    case error(Error)
    case signedIn(AccountHandle)
}

class LoginService: NSObject, ObservableObject {
    @Published var signInState: SignInState = .notSignedIn
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = HikingNetworkService()) {
        self.networkService = networkService
        super.init()
    }
    
    // Access to model
    
    var accountHandle: AccountHandle {
        if case let .signedIn(accountHandle) = signInState {
            return accountHandle
        }
        return .guestAccount
    }

    // Intents

    func silentSignIn() {
        // Automatically sign in the user.
        self.signInState = .tryingSilentSignIn
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    func logOut() {
        switch signInState {
        case .signedIn(let accountHandle):
            switch accountHandle.user.accountType {
            case .google:
                GIDSignIn.sharedInstance().signOut()
            case .guest: break
            }
        default: break
        }
        
        self.signInState = .notSignedIn
    }
}

// Google
extension LoginService: GIDSignInDelegate {

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
        Logger.logInfo("Successful Google sign-in!")
                
        self.networkService.login(idToken: user.authentication.idToken)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { _ in Logger.logInfo("Successfuly got trouver user") })
            .map { SignInState.signedIn(self.createUser(userResult: $0, accountType: .google)) }
            .catch({ error -> Just<SignInState> in
                Logger.logError("Failed to get trouver user", error: error)
                return Just(SignInState.error(error))
            })
            .assign(to: &$signInState)
    }
    
    private func createUser(userResult: WebResult<UserResult>,
                            accountType: AccountType) -> AccountHandle {
        let refreshToken: String
        if let token = userResult.headers["Set-Cookie"] as? String {
            refreshToken = token.components(separatedBy: "=")[1].components(separatedBy: ";")[0]
        } else {
            refreshToken = ""
        }
                
        let user = TrouverUser(trouverId: userResult.data.trouverId,
                               accountType: .google,
                               accessToken: userResult.data.token,
                               refreshToken: refreshToken)
        
        return AccountHandle(user: user)
    }
}
