//
//  FeedCoordinator.swift
//  Trouver
//
//  Created by Sagar Punhani on 3/20/21.
//

import Combine
import Foundation
import CoreLocation

/// Feed of hikes
class FeedCoordinator {
    enum FeedType {
        case newsfeed(CLLocationCoordinate2D)
        case favorites
    }
    
    private let networkService: NetworkService

    private var currentPage = 1
    private var canLoadMorePages = true
        
    init(networkService: NetworkService = HikingNetworkService()) {
        self.networkService = networkService
    }

    // MARK: - Internal functions
    
    func loadMoreContentIfNeeded(items: [HikeInfo],
                                 item: HikeInfo?,
                                 feedType: FeedType) -> AnyPublisher<[HikeInfo], Error> {
        guard let item = item else {
            return loadMoreContent(feedType: feedType)
        }
        
        let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            return loadMoreContent(feedType: feedType)
        }
        
        return Result.Publisher([HikeInfo]()).eraseToAnyPublisher()
    }
    
    // MARK: - Private functions
    
    private func loadMoreContent(feedType: FeedType) -> AnyPublisher<[HikeInfo], Error> {
        guard canLoadMorePages else {
            return Result.Publisher([HikeInfo]()).eraseToAnyPublisher()
        }

        return publisher(for: feedType)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: {
                Logger.logInfo("Recieved \($0.count) hikes")
            })
            .eraseToAnyPublisher()
    }

    private func publisher(for feed: FeedType) -> AnyPublisher<[HikeInfo], Error> {
        switch feed {
        case .newsfeed(let location):
            return networkService.fetchHikes(latitude: location.latitude,
                                                   longitude: location.longitude,
                                                   page: currentPage)
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
                .map { favoritesResult in favoritesResult.favorites.compactMap({ HikeInfo(hike: $0) })}
                .eraseToAnyPublisher()
        }
    }
}
