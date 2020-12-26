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

    init(networkService: NetworkService = TrailNetworkService()) {
        self.networkService = networkService
        self.fetchTrails()
    }

    // MARK: Access to the Model

    var trails: [TrailInfo] { hikingFeed.trails }

    // MARK: - Helpers

    private func fetchTrails() {
        self.cancellable = self.networkService.fetchTrails(latitude: 40.0274,
                                            longitude: -105.2519,
                                            maxDistance: 50)
            .map { trailResult in trailResult.trails.compactMap({ TrailInfo(trail: $0) })}
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished: Logger.logInfo("Fetched trails")
                    case .failure(let error): Logger.logError("Failed to get trails", error: error)
                    }
                },
                receiveValue: { [weak self] in self?.hikingFeed.trails = $0 }
            )
    }
}
