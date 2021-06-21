//
//  HikeDetail.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation
import Combine

/*
 Detail page for hike
 */
class HikeDetail: ObservableObject {
    @Published private var hikeInfo: HikeInfo
    @Published var state: State = .idle
    
    private let favoritesCoordinator: FavoritesCoordinator
    private let networkService: NetworkService

    init(hikeInfo: HikeInfo,
         favoritesCoordinator: FavoritesCoordinator,
         networkService: NetworkService = HikingNetworkService()) {
        self.hikeInfo = hikeInfo
        self.favoritesCoordinator = favoritesCoordinator
        self.networkService = networkService
    }
    
    // MARK: - Access to the model
    
    var isFavorite: Bool { hikeInfo.isFavorite }

    // MARK: - Intents

    func onAppear() {
        loadContent()
    }
    
    func onDisappear() {
        favoritesCoordinator.publishFavoriteUpdate(hikeInfo: hikeInfo)
    }
    
    func toggleFavorite() {
        hikeInfo = favoritesCoordinator.toggleFavorite(hike: hikeInfo)
    }

    private func loadContent() {
        state = .loading
        networkService.getHikeDetail(hikeId: hikeInfo.id)
            .receive(on: DispatchQueue.main)
            .map { result in State.loaded(HikeDetailInfo(hikeDetail: result.hike)) }
            .catch({ error -> Just<State> in
                Logger.logError("Failed to get hike detail", error: error)
                return Just(State.error(error))
            })
            .assign(to: &$state)
    }
}

extension HikeDetail {
    enum State {
        case idle
        case loading
        case loaded(HikeDetailInfo)
        case error(Error)
    }
}
