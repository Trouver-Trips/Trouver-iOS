//
//  FavoritesCoordinator.swift
//  Trouver
//
//  Created by Sagar Punhani on 3/21/21.
//

import Combine

class FavoritesCoordinator: ObservableObject {
    private var bag = Set<AnyCancellable>()

    let networkService: NetworkService
    @Published var favoriteFeed = HikingFeed()

    init(networkService: NetworkService = HikingNetworkService()) {
        self.networkService = networkService
    }
    
    deinit {
        bag.forEach { $0.cancel() }
    }

    func toggleFavorite(hike: HikeInfo) -> HikeInfo {
        var newHike = hike
        newHike.isFavorite = !hike.isFavorite
        save(hikeId: hike.id, addHike: !hike.isFavorite)
        return newHike
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
