//
//  HikeDetailProvider.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation
import Combine

/*
 Detail page for hike
 */
class HikeDetailProvider: ObservableObject {
    private let favoritesCoordinator: FavoritesCoordinator
    private let networkService: NetworkService
    
    @Published private var hike: Hike
    @Published var state: State = .idle

    init(hike: Hike,
         favoritesCoordinator: FavoritesCoordinator,
         networkService: NetworkService = HikingNetworkService()) {
        self.hike = hike
        self.favoritesCoordinator = favoritesCoordinator
        self.networkService = networkService
    }
    
    // MARK: - Access to the model
    
    var isFavorite: Bool { hike.isFavorite }

    // MARK: - Intents

    func onAppear() {
        loadContent()
    }
    
    func onDisappear() {
        favoritesCoordinator.publishFavoriteUpdate(hike: hike)
    }
    
    func toggleFavorite() {
        hike = favoritesCoordinator.toggleFavorite(hike: hike)
    }

    private func loadContent() {
        state = .loading
        networkService.getHikeDetail(hikeId: hike.id)
            .receive(on: DispatchQueue.main)
            .map { result in
                if let dto = result.hike {
                    return .loaded(.init(dto: dto))
                } else {
                    Logger.logError("hike detail is empty")
                    return .error(NetworkError.badOutput)
                }
            }
            .catch({ error -> Just<State> in
                Logger.logError("Failed to get hike detail", error: error)
                return Just(.error(error))
            })
            .assign(to: &$state)
    }
}

extension HikeDetailProvider {
    enum State {
        case idle
        case loading
        case loaded(HikeDetail)
        case error(Error)
    }
}
