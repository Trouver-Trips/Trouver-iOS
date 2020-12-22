//
//  FeedViewModel.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import SwiftUI

class FeedViewModel: ObservableObject {
    // Update whenever trail info changes
    @Published private var model: TrailInfo = TrailInfo(trails: [])

    private let networkService: NetworkService

    init(networkService: NetworkService = TrailNetworkService()) {
        self.networkService = networkService
        self.fetchTrails()
    }

    // MARK: Access to the Model

    var trails: [Trail] { model.trails }

    // MARK: - Helper

    private func fetchTrails() {
        self.networkService.fetchTrails(longitude: 0, latitude: 0, page: 1) { result in
            switch result {
            case .success(let trails): self.model.updateTrails(trails: trails)
            case .failure(let error): Logger.logError("Network called failed", error: error)
            }
        }
    }
}
