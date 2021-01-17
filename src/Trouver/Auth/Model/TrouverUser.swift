//
//  TrouverUser.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import Foundation

struct TrouverUser {
    let userId: String
    let fullName: String
    let givenName: String
    let familyName: String
    let email: String
    let accountType: AccountType
    let tokenRefresher: TokenRefresher
}
