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
    @Published var state: State = .idle
    private let hikeInfo: HikeInfo

    private let networkService: NetworkService

    init(hikeInfo: HikeInfo, networkService: NetworkService = HikingNetworkService()) {
        self.hikeInfo = hikeInfo
        self.networkService = networkService
    }

    // MARK: - Intents

    func onAppear() {
        self.loadContent()
    }

    private func loadContent() {
        self.state = .loading
        self.networkService.getHikeDetail(hikeId: self.hikeInfo.id)
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
