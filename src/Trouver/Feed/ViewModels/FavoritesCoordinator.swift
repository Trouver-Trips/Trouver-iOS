//
//  FavoritesCoordinator.swift
//  Trouver
//
//  Created by Sagar Punhani on 3/21/21.
//

import Combine

class FavoritesCoordinator {
    private var bag = Set<AnyCancellable>()

    let networkService: NetworkService
    @Published var favoriteHike: HikeInfo?

    init(networkService: NetworkService = HikingNetworkService()) {
        self.networkService = networkService
    }
    
    deinit {
        bag.forEach { $0.cancel() }
    }

    func updateFavorite(newHike: HikeInfo) {
        favoriteHike = nil
        favoriteHike = newHike
        save(hikeId: newHike.id, addHike: newHike.isFavorite)
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
