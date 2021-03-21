//
//  HikingFeedViewModel.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Combine
import Foundation
import CoreLocation

/*
 Main hiking feed
 */
class HikingFeedCoordinator: ObservableObject {
    // Update whenever hiking info changes
    @Published private var hikingFeed = HikingFeed()
    @Published var isLoadingPage = false

    private let networkService: NetworkService

    private var currentPage = 1
    private var canLoadMorePages = true
    private var location = CLLocationCoordinate2D(latitude: 47.6062,
                                                  longitude: -122.3321)
    private var cancellable: AnyCancellable?
    
    init(networkService: NetworkService = HikingNetworkService()) {
        self.networkService = networkService
        search(location: location)
    }
    
    deinit {
        cancellable?.cancel()
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
    
    func toggleFavorite(hike: HikeInfo) {
        var newHike = hike
        newHike.isFavorite = !hike.isFavorite
        updateHike(newHike)
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

    private func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }

        isLoadingPage = true

        cancellable = networkService.fetchHikes(latitude: location.latitude,
                                                          longitude: location.longitude,
                                                          page: currentPage)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] hikeResult in
                guard let strongSelf = self else { return }
                strongSelf.canLoadMorePages = hikeResult.hikes.hasNextPage
                strongSelf.currentPage += 1
            }, receiveCompletion: { [weak self] _ in
                self?.isLoadingPage = false
            })
            .map { hikeResult in hikeResult.hikes.docs.compactMap({ HikeInfo(hike: $0) })}
            .catch({ error -> Just<[HikeInfo]> in
                Logger.logError("Failed to get hikes", error: error)
                return Just([])
            })
            .sink(
                receiveValue: { [weak self] hikes in
                    self?.hikingFeed.addHikes(hikes)
            })
    }
    
    private func updateHike(_ hike: HikeInfo) {
        hikingFeed.updateHike(hike)
    }
}
