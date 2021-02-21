//
//  TrouverUser.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import Foundation

struct TrouverUser {
    let trouverId: String
    let accountType: AccountType
    let accessToken: String
    let refreshToken: String
    
    static var guest: TrouverUser {
        TrouverUser(trouverId: "",
                    accountType: .guest,
                    accessToken: "",
                    refreshToken: "")
    }
}
