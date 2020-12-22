//
//  TrailNetworkService.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

struct TrailNetworkService {
    private let webClient: WebClient

    init(webClient: WebClient = HTTPWebClient(host: "")) {
        self.webClient = webClient
    }
}

extension TrailNetworkService: NetworkService {
    func fetchTrails(longitude: Double, latitude: Double, page: Int, completion: @escaping Completion<[Trail]>) {
        guard let data = TrailData.trailData.data(using: .utf8) else {
            completion(.failure(ServiceError.decodeError))
            return
        }
        do {
            let trailResult = try JSONDecoder().decode(TrailResult.self, from: data)
            completion(.success(trailResult.trails))
        } catch let error {
            completion(.failure(error))
        }
    }

    func prefetch(imageUrls: [String], completion: @escaping ErrorCompletion) {
        let urlStrings = imageUrls.compactMap { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)}
        let urls = urlStrings.compactMap { URL(string: $0) }
        self.webClient.prefetch(data: urls, completion: completion)
    }
}
