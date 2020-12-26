//
//  TrailViewModel.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

/*
 Detail page for trail
 */
class TrailDetailViewModel: ObservableObject {
    @Published var trailInfo: TrailInfo

    private let networkService: NetworkService

    init(trailInfo: TrailInfo, networkService: NetworkService = TrailNetworkService()) {
        self.trailInfo = trailInfo
        self.networkService = networkService
    }

    // MARK: - Access to the model

    var name: String { trailInfo.name}
    var trailImages: [URL] { trailInfo.imageUrls }
    var weather: Int { 70 }
    var weatherDescription: String { "Sunny" }
    var roadFeatures: String { "Road conditions good" }
}
