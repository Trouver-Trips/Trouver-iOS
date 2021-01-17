//
//  GoogleTokenRefresher.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import Combine
import GoogleSignIn

struct GoogleTokenRefresher: TokenRefresher {
    let googleUser: GIDGoogleUser

    var refreshToken: Future<String, Error> {
        Future<String, Error> { promise in
            googleUser.authentication.refreshTokens { (auth, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let auth = auth {
                    promise(.success(auth.idToken))
                }
                promise(.failure(TokenError.nilToken))
            }
        }
    }
}
