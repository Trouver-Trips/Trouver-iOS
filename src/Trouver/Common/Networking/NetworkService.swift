//
//  NetworkService.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/6/21.
//

import Combine

protocol NetworkService {
    /// Get hike detail page
    func login(idToken: String) -> AnyPublisher<WebResult<UserDTO>, Error>
    
    /// Conduct a search query and return hikes
    func fetchHikes(hikeParams: HikeParams) -> AnyPublisher<HikesResultDTO, Error>

    /// Get hike detail page
    func getHikeDetail(hikeId: String) -> AnyPublisher<HikeDetailResultDTO, Error>
    
    /// Delete or update a hike
    func updateFavorite(hikeId: String, addHike: Bool) -> AnyPublisher<FavoriteActionDTO, Error>
    
    /// Get all favorites for a particular user
    func fetchFavorites(page: Int) -> AnyPublisher<FavoritesDTO, Error>
}
