//
//  FavoriteFeedCoordinator.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/6/21.
//

import Combine
import Foundation
import CoreLocation

/// Favorites
class FavoriteFeedCoordinator: ObservableObject {
    private var feedCoordinator: FeedCoordinator
    private let networkService: NetworkService
    
    private var location = CLLocationCoordinate2D(latitude: 47.6062,
                                                  longitude: -122.3321)
    private var bag = Set<AnyCancellable>()
    
    // Update whenever hiking info changes
    @Published var hikingFeed = HikingFeed()
    @Published var isLoading = false
    
    init(networkService: NetworkService = HikingNetworkService()) {
        self.networkService = networkService
        self.feedCoordinator = FeedCoordinator(networkService: networkService)
        
        // Run an initial search
        loadMoreContentIfNeeded()
    }
    
    deinit {
        bag.forEach { $0.cancel() }
    }

    // MARK: Access to the Model
    
    var hikes: [HikeInfo] { hikingFeed.hikes }

    // MARK: - Intents
    
    func loadMoreContentIfNeeded(currentItem item: HikeInfo? = nil) {
        self.isLoading = true
        feedCoordinator.loadMoreContentIfNeeded(items: hikes, item: item, feedType: .favorites)
            .catch({ error -> Just<[HikeInfo]> in
                Logger.logError("Failed to get hikes", error: error)
                return Just([])
            })
            .sink(receiveCompletion: { [weak self] _ in
                    self?.isLoading = false },
                  receiveValue: { [weak self] in
                    self?.hikingFeed.addHikes($0) })
            .store(in: &bag)
    }
}
