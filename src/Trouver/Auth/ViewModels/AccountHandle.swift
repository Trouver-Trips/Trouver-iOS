//
//  AccountHandle.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/5/21.
//

import Foundation

class AccountHandle {
    var user: TrouverUser
    
    init(user: TrouverUser) {
        self.user = user
    }
    
    static var guestAccount: AccountHandle {
        AccountHandle(user: .guest)
    }
}
