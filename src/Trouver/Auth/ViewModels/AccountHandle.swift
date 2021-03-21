//
//  AccountHandle.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/5/21.
//

import Foundation
import SwiftJWT

class AccountHandle {
    
    struct MyClaims: Claims {
        let iss: String
        let iat: Date
        let exp: Date
    }
    
    var user: TrouverUser
    private var expiryDate = Date(timeIntervalSinceNow: TimeInterval(Int.max))

    var hasExpired: Bool {
        Date() > expiryDate
    }
    
    init(user: TrouverUser) {
        self.user = user
        if user.accountType != .guest {
            updateExpiration(token: user.accessToken)
        }
        Logger.logInfo("Account Initialized: \(user.accountType)")
    }
    
    func updateToken(_ token: String) {
        user = TrouverUser(trouverId: user.trouverId,
                           accountType: user.accountType,
                           accessToken: token,
                           refreshToken: user.refreshToken)
        updateExpiration(token: user.accessToken)
        Logger.logInfo("Token Refreshed")
    }
    
    static var guestAccount: AccountHandle {
        AccountHandle(user: .guest)
    }
    
    private func updateExpiration(token: String) {
        if let expiryDate = decode(jwtToken: token) {
            self.expiryDate = expiryDate
        } else {
            self.expiryDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            Logger.logInfo("Setting default expiration")
        }
    }
    
    private func decode(jwtToken jwt: String) -> Date? {
        do {
            let newJWT = try JWT<MyClaims>(jwtString: jwt)
            let date = newJWT.claims.exp
            return date
        } catch {
            Logger.logError("Could not decode JWT")
            return nil
        }
    }
}
