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
class HikingFeedViewModel: ObservableObject {
    // Update whenever hiking info changes
    @Published private var hikingFeed = HikingFeed()
    @Published var isLoadingPage = false

    private let networkService: NetworkService

    private var currentPage = 1
    private var canLoadMorePages = true
    private var location = CLLocationCoordinate2D(latitude: 47.6062,
                                                  longitude: -122.3321)
    var usState = USState.washington

    init(networkService: NetworkService = HikingNetworkingService()) {
        self.networkService = networkService
        self.search(location: self.location, state: self.usState)
    }

    // MARK: Access to the Model

    var hikes: [HikeInfo] { hikingFeed.hikes }

    // MARK: - Intents
    
    func search(location: CLLocationCoordinate2D, state: USState) {
        self.currentPage = 1
        self.location = location
        self.usState = state
        self.hikingFeed = HikingFeed()
        self.canLoadMorePages = true
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

    private func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }

        isLoadingPage = true

        self.networkService.fetchHikes(latitude: self.location.latitude,
                                       longitude: self.location.longitude,
                                        page: currentPage,
                                        state: self.usState)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { hikeResult in
                self.canLoadMorePages = hikeResult.hikes.hasNextPage
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map { hikeResult in self.hikes + hikeResult.hikes.docs.compactMap({ HikeInfo(hike: $0) })}
            .map { HikingFeed(hikes: $0) }
            .catch({ error -> Just<HikingFeed> in
                Logger.logError("Failed to get hikes", error: error)
                return Just(self.hikingFeed)
            })
            .assign(to: &$hikingFeed)
    }
}
