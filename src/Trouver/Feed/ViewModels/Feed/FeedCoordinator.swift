//
//  FeedCoordinator.swift
//  Trouver
//
//  Created by Sagar Punhani on 3/20/21.
//

import Combine
import Foundation
import CoreLocation
import UIKit

/// Feed of hikes
class FeedCoordinator: ObservableObject {
    enum FeedType {
        case newsfeed
        case favorites
    }
    
    private let feedType: FeedType
    private let favoritesCoordinator: FavoritesCoordinator

    private var currentPage = 1
    private var canLoadMorePages = true
    private var bag = Set<AnyCancellable>()
    private var shouldUpdateFavorite: Bool = true
    
    private var location = CLLocationCoordinate2D(latitude: 47.6062,
                                                  longitude: -122.3321)
    
    private var filterOptions: FilterOptions {
        filterCoordinator.filterOptions
    }
    
    // Update whenever hiking info changes
    @Published private var hikingFeed = HikingFeed()
    @Published private(set) var isLoading = false
    
    let filterCoordinator: FilterCoordinator
        
    init(networkService: NetworkService = HikingNetworkService(),
         feedType: FeedType,
         favoritesCoordinator: FavoritesCoordinator) {
        self.networkService = networkService
        self.feedType = feedType
        self.favoritesCoordinator = favoritesCoordinator
        self.filterCoordinator = FilterCoordinator(width: UIScreen.main.bounds.width - 50)
        loadMoreContent()
        favoritesUpdated()
        optionsUpdated()
    }
    
    deinit {
        bag.forEach { $0.cancel() }
    }
    
    // MARK: - Access to the model
    
    let networkService: NetworkService
    var hikes: [HikeInfo] {
        hikingFeed.hikes.values
        .sorted {
            feedType == .newsfeed ?
                $0.timeAdded < $1.timeAdded :
                $0.timeAdded > $0.timeAdded
        }
        .map { $0.hikeInfo }
    }
    
    var showFavoriteToggle: Bool { feedType == .newsfeed }

    // MARK: - Intents
    
    func search(location: CLLocationCoordinate2D) {
        self.location = location
        refresh()
    }
    
    func loadMoreContentIfNeeded(item: HikeInfo) {
        let thresholdIndex = hikes.index(hikes.endIndex, offsetBy: -5)
        if hikes.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    func toggleFavorite(hike: HikeInfo) {
        if shouldUpdateFavorite {
            shouldUpdateFavorite = false
            let newHike = hikingFeed.toggleFavorite(hike)
            favoritesCoordinator.updateFavorite(newHike: newHike)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self]  in
                self?.shouldUpdateFavorite = true
            }
        }
    }
    
    // MARK: - Private functions
    
    private func refresh() {
        canLoadMorePages = true
        isLoading = false
        hikingFeed = HikingFeed()
        loadMoreContent()
    }
    
    private func loadMoreContent() {
        guard !isLoading && canLoadMorePages else {
            return
        }
        
        isLoading = true

        publisher()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] in
                guard let strongSelf = self else { return }
                Logger.logInfo("Recieved \($0.count) hikes for \(strongSelf.feedType)")
            })
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

    private func publisher() -> AnyPublisher<[HikeInfo], Error> {
        switch feedType {
        case .newsfeed:
            return networkService.fetchHikes(hikeParams:
                HikeParams(latitude: location.latitude,
                           longitude: location.longitude,
                           difficulty: filterOptions.difficulty,
                           elevationMin: filterOptions.elevationMin,
                           elevationMax: filterOptions.elevationMax,
                           lengthMin: filterOptions.lengthMin,
                           lengthMax: filterOptions.lengthMax,
                           sortType: filterOptions.sort,
                           page: currentPage))
                .handleEvents(receiveOutput: { [weak self] hikeResult in
                    guard let strongSelf = self else { return }
                    strongSelf.canLoadMorePages = hikeResult.hikes.hasNextPage
                    strongSelf.currentPage += 1
                })
                .map { hikeResult in hikeResult.hikes.docs.compactMap({ HikeInfo(hike: $0) })}
                .eraseToAnyPublisher()
        case .favorites:
            return networkService.fetchFavorites(page: currentPage)
                .handleEvents(receiveOutput: { [weak self] favoritesResult in
                    guard let strongSelf = self else { return }
                    strongSelf.canLoadMorePages = favoritesResult.hasNextPage
                    strongSelf.currentPage += 1
                })
                .map { favoritesResult in
                    // Remove results without images
                    favoritesResult.favorites.compactMap({ $0.images.isEmpty ? nil : HikeInfo(hike: $0) })
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func favoritesUpdated() {
        if feedType == .favorites {
            favoritesCoordinator.$favoriteHike
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .sink(receiveValue: { [weak self] in
                if let updatedHike = $0 {
                    if updatedHike.isFavorite {
                        self?.hikingFeed.addHikes(updatedHike, toFront: true)
                    } else {
                        self?.hikingFeed.removeHike(updatedHike)
                    }
                }
            })
            .store(in: &bag)
        }
    }
    
    private func optionsUpdated() {
        if feedType == .newsfeed {
            filterCoordinator.$filterOptions
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .sink(receiveValue: { [weak self] _ in
                self?.refresh()
            })
            .store(in: &bag)
        }
    }
    
    private func printOptions() {
        let filterMirror = Mirror(reflecting: filterCoordinator.filterOptions)
        let properties = filterMirror.children
        
        let output = properties.map { "\($0.label!) = \($0.value)"}

        Logger.logInfo(output.joined(separator: "\n"))
    }
}
