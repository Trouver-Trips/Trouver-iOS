//
//  HikeViewModel.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation
import Combine

/*
 Detail page for hike
 */
class HikeDetailViewModel: ObservableObject {
    @Published var hikeInfo: HikeInfo
    @Published var hikeDetailInfo: HikeDetailInfo?

    private let networkService: NetworkService

    init(hikeInfo: HikeInfo, networkService: NetworkService = HikingNetworkingService()) {
        self.hikeInfo = hikeInfo
        self.networkService = networkService
    }

    // MARK: - Access to the model

    var name: String { hikeDetailInfo?.name ?? hikeInfo.name }
    var hikeImages: [URL] { hikeDetailInfo?.imageUrls ?? hikeInfo.imageUrls }
    var attributes: [String] { hikeDetailInfo?.attrributes ?? [] }

    // MARK: - Intents

    func onAppear() {
        self.loadContent()
    }

    private func loadContent() {
        self.networkService.getHikeDetail(id: self.hikeInfo.id, state: .washington)
            .receive(on: DispatchQueue.main)
            .map { result in HikeDetailInfo(hikeDetail: result.hike) }
            .catch({ error -> Just<HikeDetailInfo?> in
                Logger.logError("Failed to get hike detail", error: error)
                return Just(self.hikeDetailInfo)
            })
            .assign(to: &$hikeDetailInfo)
    }
}
