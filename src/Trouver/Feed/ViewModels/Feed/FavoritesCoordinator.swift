//
//  FavoritesCoordinator.swift
//  Trouver
//
//  Created by Sagar Punhani on 3/21/21.
//

import Combine

class FavoritesCoordinator {
    @Published private(set) var favoriteHike: Hike?
    private var bag = Set<AnyCancellable>()

    let networkService: NetworkService

    init(networkService: NetworkService = HikingNetworkService()) {
        self.networkService = networkService
    }
    
    deinit {
        bag.forEach { $0.cancel() }
    }

    func toggleFavorite(hike: Hike) -> Hike {
        var newHike = hike
        newHike.isFavorite.toggle()
        save(hikeId: newHike.id, addHike: newHike.isFavorite)
        return newHike
    }
    
    func publishFavoriteUpdate(hike: Hike) {
        self.favoriteHike = hike
    }
    
    private func save(hikeId: String, addHike: Bool) {

        // catch errors
        networkService.updateFavorite(hikeId: hikeId, addHike: addHike)
            .sink(receiveCompletion: { error in
                if case let .failure(error) = error {
                    Logger.logError("Could not favorite", error: error)
                }
            }, receiveValue: { _ in
                Logger.logInfo("Successfully \(addHike ? "Added" : "Deleted") Favorite")
            })
            .store(in: &bag)
    }
}
