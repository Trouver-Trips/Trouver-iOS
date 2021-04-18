//
//  ServiceValues.swift
//  Trouver
//
//  Created by Sagar Punhani on 3/27/21.
//

import Foundation

enum APIPath: Equatable {
    private static let version = "v1"

    case login
    case feeds
    case hikes(String)
    case users(String)
    case refreshToken

    private var label: String {
        let mirror = Mirror(reflecting: self)
        if let label = mirror.children.first?.label {
            return label
        } else {
            return String(describing: self)
        }
    }
    
    var path: String {
        let root = "/\(APIPath.version)/\(label)"
        switch self {
        case .login, .feeds, .refreshToken: return root
        case .hikes(let id):
            return "\(root)/\(id)"
        case .users(let id):
            return "\(root)/\(id)/favorites"
        }
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

enum Difficulty: String {
    case unknown
    case easy
    case moderate
    case hard
    
    init(from value: Int) {
        switch value {
        case 1: self = .easy
        case 3, 5: self = .moderate
        case 7: self = .hard
        default: self = .unknown
        }
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
