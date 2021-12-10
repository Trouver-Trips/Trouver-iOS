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

class LoginService: ObservableObject {
    private let signInConfig: GIDConfiguration
    private let networkService: NetworkService
    
    @Published var signInState: SignInState = .notSignedIn
    
    init(networkService: NetworkService = HikingNetworkService()) {
        self.signInConfig = .init(clientID: "14106003132-6e5p3gnulc32uall0qn9hdumh1jpvgbf.apps.googleusercontent.com")
        self.networkService = networkService
    }
    
    // Access to model
    
    var accountHandle: AccountHandle {
        if case let .signedIn(accountHandle) = signInState {
            return accountHandle
        }
        return .guestAccount
    }

    // Intents
    
    func signIn() {
        GIDSignIn.sharedInstance.signIn(with: self.signInConfig,
                                        presenting: UIApplication.currentViewController,
                                        callback: self.handleCallback)
    }

    func silentSignIn() {
        // Automatically sign in the user.
        signInState = .tryingSilentSignIn
        GIDSignIn.sharedInstance.restorePreviousSignIn(callback: self.handleCallback)
    }

    func logOut() {
        switch signInState {
        case .signedIn(let accountHandle):
            switch accountHandle.user.accountType {
            case .google:
                GIDSignIn.sharedInstance.signOut()
            case .guest: break
            }
        default: break
        }
        
        signInState = .notSignedIn
    }
}

// Google
extension LoginService {
    private func handleCallback(user: GIDGoogleUser?, error: Error?) {
        if let error = error as NSError? {
            signInState = .notSignedIn
            if error.code == GIDSignInError.hasNoAuthInKeychain.rawValue {
                Logger.logInfo("The user has not signed in before or they have since signed out.")
            } else if error.code == GIDSignInError.canceled.rawValue {
                Logger.logInfo("Google Sign In cancelled")
            } else {
                Logger.logError("Google Sign In errored", error: error)
            }
            
            return
        }

        // If the previous `error` is null, then the sign-in was succesful
        Logger.logInfo("Successful Google sign-in!")
                
        networkService.login(idToken: user?.authentication.idToken ?? "")
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { _ in Logger.logInfo("Successfuly got trouver user") })
            .map { SignInState.signedIn(LoginService.createUser(userResult: $0, accountType: .google)) }
            .catch({ error -> Just<SignInState> in
                Logger.logError("Failed to get trouver user", error: error)
                return Just(SignInState.error(error))
            })
            .assign(to: &$signInState)
    }
    
    private static func createUser(userResult: WebResult<UserDTO>,
                                   accountType: AccountType) -> AccountHandle {
        let refreshToken: String
        if let token = userResult.headers["Set-Cookie"] as? String {
            refreshToken = token.components(separatedBy: "=")[1].components(separatedBy: ";")[0]
        } else {
            refreshToken = ""
        }
                
        let user = TrouverUser(trouverId: userResult.data.trouverId ?? "",
                               accountType: .google,
                               accessToken: userResult.data.token ?? "",
                               refreshToken: refreshToken)
        
        return AccountHandle(user: user)
    }
}
