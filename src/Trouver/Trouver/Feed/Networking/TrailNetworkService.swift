//
//  TrailNetworkService.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Combine
import Foundation

enum APIPath: String {
    case trails = "/data/get-trails"
}

protocol NetworkService {
    /**
     Conduct a search query and return trails
     */
    func fetchTrails(latitude: Double,
                     longitude: Double,
                     maxDistance: Int) -> AnyPublisher<TrailResult, Error>
}

struct TrailNetworkService {
    private let host = "www.hikingproject.com"
    private let apiKey = "200964296-8b941c199cdcf93d36af89ac419ebc66"
    private let webClient: WebClient

    init(webClient: WebClient = HttpWebClient()) {
        self.webClient = webClient
    }
}

extension TrailNetworkService: NetworkService {
    func fetchTrails(latitude: Double,
                     longitude: Double,
                     maxDistance: Int) -> AnyPublisher<TrailResult, Error> {
        let params = [
            "lat": latitude.description,
            "lon": longitude.description,
            "maxDistance": maxDistance.description
        ]
        return self.request(path: APIPath.trails, params: params)
    }

    func request<T: Decodable>(path: APIPath, params: [String: String?]) -> AnyPublisher<T, Error> {
        var components = URLComponents()
        var queryItems = [URLQueryItem(name: "key", value: apiKey)]
        components.scheme = "https"
        components.host = host
        components.path = path.rawValue
        queryItems.append(contentsOf: params.map { URLQueryItem(name: $0, value: $1) })
        components.queryItems = queryItems
        guard let url = components.url else {
            preconditionFailure("URL is invalid")
        }
        return self.webClient.request(URLRequest(url: url))
    }
}
