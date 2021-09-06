//
//  PreviewHikingService.swift
//  Trouver
//
//  Created by Sagar Punhani on 5/24/21.
//

import Combine

struct PreviewHikingService: NetworkService {
    func login(idToken: String) -> AnyPublisher<WebResult<UserDTO>, Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func fetchHikes(hikeParams: HikeParams) -> AnyPublisher<HikesResultDTO, Error> {
        CurrentValueSubject(HikesResultDTO.sampleData())
            .eraseToAnyPublisher()
    }
    
    func getHikeDetail(hikeId: String) -> AnyPublisher<HikeDetailResultDTO, Error> {
        CurrentValueSubject(HikeDetailResultDTO.sampleData())
            .eraseToAnyPublisher()
    }
    
    func updateFavorite(hikeId: String, addHike: Bool) -> AnyPublisher<FavoriteActionDTO, Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func fetchFavorites(page: Int) -> AnyPublisher<FavoritesDTO, Error> {
        Empty().eraseToAnyPublisher()
    }
}
