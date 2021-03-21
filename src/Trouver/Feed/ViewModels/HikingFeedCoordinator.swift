//
//  HikingFeedViewModel.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Combine
import Foundation
import CoreLocation

/// Main Hiking feed
class HikingFeedCoordinator: ObservableObject {

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
        search(location: self.location)
    }
    
    deinit {
        bag.forEach { $0.cancel() }
    }

    // MARK: Access to the Model
    
    var hikes: [HikeInfo] { hikingFeed.hikes }

    // MARK: - Intents
    
    func search(location: CLLocationCoordinate2D) {
        self.location = location
        hikingFeed = HikingFeed()
        feedCoordinator = FeedCoordinator(networkService: networkService)
        loadMoreContentIfNeeded()
    }
    
    func loadMoreContentIfNeeded(currentItem item: HikeInfo? = nil) {
        self.isLoading = true
        feedCoordinator.loadMoreContentIfNeeded(items: hikes, item: item, feedType: .newsfeed(location))
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
    
//    func toggleFavorite(hike: HikeInfo) {
//        hikingFeed.toggleFavorite(hike: hike)
//        favoriteFeed.updateFeed(hike: hike, addHike: !hike.isFavorite)
//    }
//
//    func toggleFavorite(hike: HikeInfo) {
//        var newHike = hike
//        newHike.isFavorite = !hike.isFavorite
//        save(hikeId: hike.id, addHike: !hike.isFavorite)
//    }
//
//    private func save(hikeId: String, addHike: Bool) {
//
//        // catch errors
//        networkService.updateFavorite(hikeId: hikeId, addHike: addHike)
//            .sink(receiveCompletion: { error in
//                if case let .failure(error) = error {
//                    Logger.logError("Could not favorite", error: error)
//                }
//            }, receiveValue: { _ in
//                Logger.logInfo("Successfully \(addHike ? "Added" : "Deleted") Favorite")
//            })
//            .store(in: &bag)
//
//    }
//
}
