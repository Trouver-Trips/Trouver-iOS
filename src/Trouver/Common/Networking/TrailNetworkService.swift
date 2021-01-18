//
//  TrailNetworkService.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Combine
import Foundation

enum APIPath: String {
    case trails = "/feeds"
}

enum State: String {
    case washington
    case california
    case oregon
}

protocol NetworkService {
    /**
     Conduct a search query and return trails
     */
    func fetchTrails(latitude: Double,
                     longitude: Double,
                     page: Int,
                     state: State) -> AnyPublisher<TrailResult, Error>
}

struct TrailNetworkService {
    private let host = EnvironmentProvider.host
    private let webClient: WebClient

    init(webClient: WebClient = HttpWebClient()) {
        self.webClient = webClient
    }
}

extension TrailNetworkService: NetworkService {
    func fetchTrails(latitude: Double,
                     longitude: Double,
                     page: Int,
                     state: State) -> AnyPublisher<TrailResult, Error> {
        let params = [
            "lat": latitude.description,
            "long": longitude.description,
            "page": page.description,
            "state": state.rawValue
        ]
        return self.request(path: APIPath.trails, params: params)
    }

    func request<T: Decodable>(path: APIPath, params: [String: String?]) -> AnyPublisher<T, Error> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path.rawValue
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else {
            preconditionFailure("URL is invalid")
        }
        return self.webClient.request(URLRequest(url: url))
    }
}
