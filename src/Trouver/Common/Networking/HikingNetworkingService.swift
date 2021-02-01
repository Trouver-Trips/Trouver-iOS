//
//  HikingNetworkService.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Combine
import Foundation

enum APIPath: String {
    case feed = "/feeds"
    case hikeDetail = "/hikes"

    func addHikeId(id: String) -> String {
        "\(self.rawValue)/\(id)"
    }
}

enum USState: String {
    case washington
    case california
    case oregon
    case unknown
}

protocol NetworkService {
    /**
     Conduct a search query and return hikes
     */
    func fetchHikes(latitude: Double,
                    longitude: Double,
                    page: Int,
                    state: USState) -> AnyPublisher<HikeResult, Error>

    /**
     Get hike detail page
     */
    func getHikeDetail(id: String, state: USState) -> AnyPublisher<HikeDetailResult, Error>
}

struct HikingNetworkingService {
    private let host = EnvironmentProvider.host
    private let webClient: WebClient

    init(webClient: WebClient = HttpWebClient()) {
        self.webClient = webClient
    }
}

extension HikingNetworkingService: NetworkService {

    func fetchHikes(latitude: Double,
                    longitude: Double,
                    page: Int,
                    state: USState) -> AnyPublisher<HikeResult, Error> {
        let params = [
            "lat": latitude.description,
            "long": longitude.description,
            "page": page.description,
            "state": state.rawValue
        ]

        return self.request(path: APIPath.feed.rawValue, params: params)
    }

    func getHikeDetail(id: String, state: USState) -> AnyPublisher<HikeDetailResult, Error> {
        let params = [
            "state": state.rawValue
        ]

        return self.request(path: APIPath.hikeDetail.addHikeId(id: id), params: params)
    }

    private func request<T: Decodable>(path: String, params: [String: String?]) -> AnyPublisher<T, Error> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else {
            preconditionFailure("URL is invalid")
        }
        return self.webClient.request(URLRequest(url: url))
    }
}
