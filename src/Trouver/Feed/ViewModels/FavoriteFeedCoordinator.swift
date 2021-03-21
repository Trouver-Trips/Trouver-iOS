//
//  FavoriteFeedCoordinator.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/6/21.
//

import Combine
import Foundation
import CoreLocation

/*
Favorite Feed
 */
class FavoriteFeedCoordinator: ObservableObject {
    // Update whenever hiking info changes
    @Published private var hikingFeed = HikingFeed()
    @Published var isLoadingPage = false

    private let networkService: NetworkService

    private var currentPage = 1
    private var canLoadMorePages = true
    private var location = CLLocationCoordinate2D(latitude: 47.6062,
                                                  longitude: -122.3321)
    private var cancellable: AnyCancellable?
    private var updateFavoriteCancellable: AnyCancellable?
    
    init(networkService: NetworkService = HikingNetworkService()) {
        self.networkService = networkService
        search(location: location)
    }
    
    deinit {
        cancellable?.cancel()
        updateFavoriteCancellable?.cancel()
    }

    // MARK: Access to the Model

    var hikes: [HikeInfo] { hikingFeed.hikes }

    // MARK: - Intents
    
    func search(location: CLLocationCoordinate2D) {
        currentPage = 1
        self.location = location
        hikingFeed.clearHikes()
        canLoadMorePages = true
        loadMoreContent()
    }

    func loadMoreContentIfNeeded(currentItem item: HikeInfo?) {
        guard let item = item else {
            loadMoreContent()
            return
        }

        let items = hikingFeed.hikes
        let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
          loadMoreContent()
        }
    }
    
    func update(_ hike: HikeInfo) {
        if !hike.isFavorite {
            hikingFeed.addHikes(hike)
        } else {
            hikingFeed.removeHike(hike)
        }
        save(hikeId: hike.id, addHike: !hike.isFavorite)
    }

    private func save(hikeId: String, addHike: Bool) {
        
        // catch errors
        updateFavoriteCancellable = networkService.updateFavorite(hikeId: hikeId, addHike: addHike)
            .sink(receiveCompletion: { error in
                if case let .failure(error) = error {
                    Logger.logError("Could not favorite", error: error)
                }
            }, receiveValue: { _ in
                Logger.logInfo("Successfully \(addHike ? "Added" : "Deleted") Favorite")
            })
    }

    private func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }

        isLoadingPage = true

        cancellable = networkService.fetchFavorites(page: currentPage)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] favoritesResult in
                guard let strongSelf = self else { return }
                strongSelf.canLoadMorePages = favoritesResult.hasNextPage
                strongSelf.currentPage += 1
            }, receiveCompletion: { [weak self] _ in
                self?.isLoadingPage = false
            })
            .map { favoritesResult in favoritesResult.favorites.compactMap({ HikeInfo(hike: $0) })}
            .catch({ error -> Just<[HikeInfo]> in
                Logger.logError("Failed to get hikes", error: error)
                return Just([])
            })
            .sink(
                receiveValue: { [weak self] in self?.hikingFeed.addHikes($0) })
    }
}
