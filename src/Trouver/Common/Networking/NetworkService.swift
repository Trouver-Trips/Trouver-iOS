//
//  NetworkService.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/6/21.
//

import Combine

protocol NetworkService {
    /// Get hike detail page
    func login(idToken: String) -> AnyPublisher<WebResult<UserResult>, Error>
    
    /// Conduct a search query and return hikes
    func fetchHikes(hikeParams: HikeParams) -> AnyPublisher<HikeResult, Error>

    /// Get hike detail page
    func getHikeDetail(hikeId: String) -> AnyPublisher<HikeDetailResult, Error>
    
    /// Delete or update a hike
    func updateFavorite(hikeId: String, addHike: Bool) -> AnyPublisher<FavoriteActionResult, Error>
    
    /// Get all favorites for a particular user
    func fetchFavorites(page: Int) -> AnyPublisher<FavoritesResult, Error>
}
