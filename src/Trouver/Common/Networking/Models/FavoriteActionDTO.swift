//
//  FavoriteActionDTO.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/6/21.
//

import Foundation

// MARK: - FavoriteActionResult
struct FavoriteActionDTO: Codable {
    let message, trouverID, name: String?
    let favorites: [String]?

    enum CodingKeys: String, CodingKey {
        case message
        case trouverID = "trouverId"
        case name, favorites
    }
}
