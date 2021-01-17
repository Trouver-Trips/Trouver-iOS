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

    private let networkService: NetworkService

    private var cancellable: AnyCancellable?
    private var currentPage = 0

    init(networkService: NetworkService = TrailNetworkService()) {
        self.networkService = networkService
    }

    // MARK: Access to the Model

    var trails: [TrailInfo] { hikingFeed.trails }

    // MARK: - Intents

    func fetchTrails() {
        self.currentPage += 1
        self.cancellable = self.networkService.fetchTrails(latitude: 47.6062,
                                                           longitude: -122.3321,
                                                           page: currentPage,
                                                           state: .washington)
            .map { trailResult in trailResult.hikes.docs.compactMap({ TrailInfo(trail: $0) })}
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished: Logger.logInfo("Fetched trails")
                    case .failure(let error): Logger.logError("Failed to get trails", error: error)
                    }
                },
                receiveValue: { [weak self] in self?.hikingFeed.trails.append(contentsOf: $0) }
            )
    }
}
