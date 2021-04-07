//
//  ServiceValues.swift
//  Trouver
//
//  Created by Sagar Punhani on 3/27/21.
//

import Foundation

enum APIPath: String {
    case login = "/login"
    case feed = "/feeds"
    case hikeDetail = "/hikes"
    case users = "/users"
    case refresh = "/refreshToken"

    func addHikeId(_ id: String) -> String {
        "\(rawValue)/\(id)"
    }
    
    func addFavoriteId(_ id: String) -> String {
        "\(rawValue)/\(id)/favorites"
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidUrl
    case badOutput
}

enum Difficulty: Int {
    case easy
    case medium
    case hard
    case unknown
    
    var name: String {
        return String(describing: self)
    }
}

enum SortType: String {
    case popularity
    case closest
}

struct HikeParams {
    let latitude: Double
    let longitude: Double
    let difficulty: [Difficulty]
    let elevationMin: Int
    let elevationMax: Int
    let lengthMin: Int
    let lengthMax: Int
    let sortType: SortType
    let page: Int
    
    init(latitude: Double,
         longitude: Double,
         difficulty: [Difficulty] = [],
         elevationMin: Int = 0,
         elevationMax: Int = Int.max,
         lengthMin: Int = 0,
         lengthMax: Int = Int.max,
         sortType: SortType = .closest,
         page: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.difficulty = difficulty
        self.elevationMin = elevationMin
        self.elevationMax = elevationMax
        self.lengthMin = lengthMin
        self.lengthMax = lengthMax
        self.sortType = sortType
        self.page = page
    }
}
