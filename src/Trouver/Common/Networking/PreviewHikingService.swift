//
//  PreviewHikingService.swift
//  Trouver
//
//  Created by Sagar Punhani on 5/24/21.
//

import Combine

struct PreviewHikingService: NetworkService {
    func login(idToken: String) -> AnyPublisher<WebResult<UserResult>, Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func fetchHikes(hikeParams: HikeParams) -> AnyPublisher<HikeResult, Error> {
        CurrentValueSubject(HikeResult.sampleData())
            .eraseToAnyPublisher()
    }
    
    func getHikeDetail(hikeId: String) -> AnyPublisher<HikeDetailResult, Error> {
        CurrentValueSubject(HikeDetailResult.sampleData())
            .eraseToAnyPublisher()
    }
    
    func updateFavorite(hikeId: String, addHike: Bool) -> AnyPublisher<FavoriteActionResult, Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func fetchFavorites(page: Int) -> AnyPublisher<FavoritesResult, Error> {
        Empty().eraseToAnyPublisher()
    }
}
