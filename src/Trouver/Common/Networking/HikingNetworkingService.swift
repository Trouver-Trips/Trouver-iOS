//
//  HikingNetworkService.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Combine
import Foundation

enum APIPath: String {
    case login = "/login"
    case feed = "/feeds"
    case hikeDetail = "/hikes"

    func addHikeId(id: String) -> String {
        "\(self.rawValue)/\(id)"
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case invalidUrl
}

protocol NetworkService {
    /**
     Get hike detail page
     */
    func login(idToken: String) -> AnyPublisher<UserResult, Error>
    
    /**
     Conduct a search query and return hikes
     */
    func fetchHikes(latitude: Double,
                    longitude: Double,
                    page: Int) -> AnyPublisher<HikeResult, Error>

    /**
     Get hike detail page
     */
    func getHikeDetail(id: String) -> AnyPublisher<HikeDetailResult, Error>
}

struct HikingNetworkingService {
    private let host = EnvironmentProvider.host
    private let webClient: WebClient
    private let accountHandle: AccountHandle
    
    private var defaultHeaders: [String: String] {
        ["Authorization": accountHandle.user.accessToken]
    }

    init(webClient: WebClient = HttpWebClient(), accountHandle: AccountHandle = .guestAccount) {
        self.webClient = webClient
        self.accountHandle = accountHandle
    }
}

extension HikingNetworkingService: NetworkService {

    func login(idToken: String) -> AnyPublisher<UserResult, Error> {
        let headers = [
            "Authorization": idToken
        ]
        
        return self.request(httpMethod: .post, path: APIPath.login.rawValue, headers: headers)
    }

    func fetchHikes(latitude: Double,
                    longitude: Double,
                    page: Int) -> AnyPublisher<HikeResult, Error> {
        let params = [
            "lat": latitude.description,
            "long": longitude.description,
            "page": page.description
        ]

        return self.request(path: APIPath.feed.rawValue, params: params)
    }

    func getHikeDetail(id: String) -> AnyPublisher<HikeDetailResult, Error> {
        self.request(path: APIPath.hikeDetail.addHikeId(id: id))
    }

    private func request<T: Decodable>(httpMethod: HTTPMethod = .get,
                                       path: String,
                                       headers: [String: String]? = nil,
                                       params: [String: String?] = [:]) -> AnyPublisher<T, Error> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else {
            return Fail(error: NetworkError.invalidUrl).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        let allHeaders = headers ?? defaultHeaders
        allHeaders.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        return self.webClient.request(request)
    }
}
