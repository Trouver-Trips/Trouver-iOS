//
//  FavoritesResult.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/6/21.
//

import Foundation

// MARK: - FavoritesResult
struct FavoritesResult: Codable {
    let message, trouverID, name: String
    let totalFavorites: Int
    let numPages: Int
    let hasNextPage: Bool
    let favorites: [HikeDoc]

    enum CodingKeys: String, CodingKey {
        case message
        case trouverID = "trouverId"
        case name, totalFavorites, numPages, hasNextPage, favorites
    }
}
