//
//  NetworkService.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/6/21.
//

import Combine

enum APIPath: String {
    case login = "/login"
    case feed = "/feeds"
    case hikeDetail = "/hikes"
    case users = "/users"

    func addHikeId(_ id: String) -> String {
        "\(self.rawValue)/\(id)"
    }
    
    func addFavoriteId(_ id: String) -> String {
        "\(self.rawValue)/\(id)/favorites"
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidUrl
}

protocol NetworkService {
    /**
     Get hike detail page
     */
    func login(idToken: String) -> AnyPublisher<UserResult, Error>
    
    /**
     Conduct a search query and return hikes
     */
    func fetchHikes(latitude: Double,
                    longitude: Double,
                    page: Int) -> AnyPublisher<HikeResult, Error>

    /**
     Get hike detail page
     */
    func getHikeDetail(hikeId: String) -> AnyPublisher<HikeDetailResult, Error>
    
    /**
     Delete or update a hike
     */
    func updateFavorite(hikeId: String, addHike: Bool) -> AnyPublisher<FavoriteActionResult, Error>
    
    /**
     Get all favorites for a particular user
     */
    func fetchFavorites(page: Int) -> AnyPublisher<FavoritesResult, Error>
}
