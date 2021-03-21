//
//  TokenRefreshResult.swift
//  Trouver
//
//  Created by Sagar Punhani on 3/20/21.
//

import Foundation

// MARK: - FavoriteActionResult
struct TokenRefreshResult: Codable {
    let message: String
    let token: String?
}
