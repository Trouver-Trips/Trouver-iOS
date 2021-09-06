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
    
    enum ViewState {
        case loading
        case loaded
        case error
    }
    
    private let locationProvider = LocationProvider()
    private let feedType: FeedType

    private var currentPage = 1
    private var canLoadMorePages = true
    private var bag = Set<AnyCancellable>()
    private var shouldUpdateFavorite: Bool = true
    
    private var location = LocationProvider.defaultLocation
    
    private var filterOptions: FilterOptions {
        filterCoordinator.filterOptions
    }
    
    // Update whenever hiking info changes
    @Published private var hikingFeed = HikingFeed()
    @Published private(set) var viewState = ViewState.loading
    
    let filterCoordinator: FilterCoordinator
    let favoritesCoordinator: FavoritesCoordinator
        
    init(networkService: NetworkService = HikingNetworkService(),
         feedType: FeedType,
         favoritesCoordinator: FavoritesCoordinator) {
        self.networkService = networkService
        self.feedType = feedType
        self.favoritesCoordinator = favoritesCoordinator
        self.filterCoordinator = FilterCoordinator(width: UIScreen.main.bounds.width - 50)
        
        getCurrentLocation()
        favoritesUpdated()
    }
    
    deinit {
        bag.forEach { $0.cancel() }
    }
    
    // MARK: - Access to the model
    
    let networkService: NetworkService
    var hikes: [Hike] {
        hikingFeed.hikes.values
        .sorted {
            feedType == .newsfeed ?
                $0.timeAdded < $1.timeAdded :
                $0.timeAdded > $0.timeAdded
        }
        .map { $0.hike }
    }
    
    // MARK: - Intents
    
    func search(location: CLLocationCoordinate2D = LocationProvider.defaultLocation) {
        self.location = location
        refresh()
    }
    
    func loadMoreContentIfNeeded(hike: Hike) {
        let thresholdIndex = hikes.index(hikes.endIndex, offsetBy: -3)
        if hikes.firstIndex(where: { $0.id == hike.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    // MARK: - Private functions
    
    private func getCurrentLocation() {
        if feedType == .newsfeed {
            locationProvider.$lastLocation.sink(receiveValue: { [weak self] loc in
                if let coordinate = loc?.coordinate {
                    self?.search(location: coordinate)
                }
            })
            .store(in: &bag)
            locationProvider.$locationStatus.sink(receiveValue: { [weak self] status in
                if let status = status,
                   status == .denied,
                   status == .restricted {
                    self?.refresh()
                }
            })
            .store(in: &bag)
        } else {
            refresh()
        }
    }
    
    private func refresh() {
        canLoadMorePages = true
        viewState = .loaded
        hikingFeed = HikingFeed()
        loadMoreContent()
    }
    
    private func loadMoreContent() {
        guard viewState != .loading && canLoadMorePages else {
            return
        }
        
        viewState = .loading

        publisher()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] in
                guard let strongSelf = self else { return }
                Logger.logInfo("Recieved \($0.count) hikes for \(strongSelf.feedType)")
            })
            .catch({ [weak self] error -> Just<[Hike]> in
                Logger.logError("Failed to get hikes", error: error)
                self?.viewState = .error
                return Just([])
            })
            .sink(receiveValue: { [weak self] in
                    self?.viewState = .loaded
                    self?.hikingFeed.addHikes($0) })
            .store(in: &bag)
    }

    private func publisher() -> AnyPublisher<[Hike], Error> {
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
                    strongSelf.canLoadMorePages = hikeResult.hikes?.hasNextPage ?? false
                    strongSelf.currentPage += 1
                })
                // Remove results without images
                .map { hikeResult in
                    hikeResult.hikes?.docs?.compactMap({ $0.images?.isEmpty == true ? nil : Hike(dto: $0) }) ?? []
                }
                .eraseToAnyPublisher()
        case .favorites:
            return networkService.fetchFavorites(page: currentPage)
                .handleEvents(receiveOutput: { [weak self] favoritesResult in
                    guard let strongSelf = self else { return }
                    strongSelf.canLoadMorePages = favoritesResult.hasNextPage ?? false
                    strongSelf.currentPage += 1
                })
                .map { favoritesResult in
                    // Remove results without images
                    favoritesResult.favorites?.compactMap({ $0.images?.isEmpty == true ? nil : Hike(dto: $0) }) ?? []
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
                        self?.hikingFeed.addHikes(updatedHike)
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
