//
//  HikingFeedViewModel.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Combine
import Foundation

/*
 Main hiking feed
 */
class HikingFeedViewModel: ObservableObject {
    // Update whenever trail info changes
    @Published private var hikingFeed = HikingFeed()
    @Published var isLoadingPage = false

    private var currentPage = 1
    private var canLoadMorePages = true
    private let networkService: NetworkService

    init(networkService: NetworkService = TrailNetworkService()) {
        self.networkService = networkService
        loadMoreContent()
    }

    // MARK: Access to the Model

    var trails: [TrailInfo] { hikingFeed.trails }

    // MARK: - Intents

    func loadMoreContentIfNeeded(currentItem item: TrailInfo?) {
        guard let item = item else {
            loadMoreContent()
            return
        }

        let items = hikingFeed.trails
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

        self.networkService.fetchTrails(latitude: 47.6062,
                                        longitude: -122.3321,
                                        page: currentPage,
                                        state: .washington)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { trailResult in
                self.canLoadMorePages = trailResult.hikes.hasNextPage
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map { trailResult in self.trails + trailResult.hikes.docs.compactMap({ TrailInfo(trail: $0) })}
            .map { HikingFeed(trails: $0) }
            .catch({ error -> Just<HikingFeed> in
                Logger.logError("Failed to get trails", error: error)
                return Just(self.hikingFeed)
            })
            .assign(to: &$hikingFeed)
    }
}
