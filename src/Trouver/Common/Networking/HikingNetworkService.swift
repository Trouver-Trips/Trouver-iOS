//
//  HikingNetworkService.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Combine
import Foundation

struct HikingNetworkService {
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

extension HikingNetworkService: NetworkService {

    func login(idToken: String) -> AnyPublisher<WebResult<UserResult>, Error> {
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
            "page": page.description,
            "trouverId": self.accountHandle.user.trouverId
        ]

        return self.request(path: APIPath.feed.rawValue, params: params)
    }

    func getHikeDetail(hikeId: String) -> AnyPublisher<HikeDetailResult, Error> {
        self.request(path: APIPath.hikeDetail.addHikeId(hikeId))
    }
    
    func updateFavorite(hikeId: String, addHike: Bool) -> AnyPublisher<FavoriteActionResult, Error> {
        let httpMethod: HTTPMethod = addHike ? .post : .delete
        let path = APIPath.users.addFavoriteId(self.accountHandle.user.trouverId)
        let params = [
            "hikeId": hikeId
        ]
        
        return self.request(httpMethod: httpMethod, path: path, params: params)
    }
    
    func fetchFavorites(page: Int) -> AnyPublisher<FavoritesResult, Error> {
        let path = APIPath.users.addFavoriteId(self.accountHandle.user.trouverId)
        let params = [
            "page": page.description
        ]
        
        return self.request(path: path, params: params)
    }
    
    private func buildRequest(httpMethod: HTTPMethod = .get,
                              path: String,
                              headers: [String: String]? = nil,
                              params: [String: String?] = [:]) -> Result<URLRequest, Error> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else {
            return .failure(NetworkError.invalidUrl)
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        let allHeaders = headers ?? defaultHeaders
        allHeaders.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        return .success(request)
    }
    
    private func request<T: Decodable>(httpMethod: HTTPMethod = .get,
                                       path: String,
                                       headers: [String: String]? = nil,
                                       params: [String: String?] = [:]) -> AnyPublisher<T, Error> {
        switch buildRequest(httpMethod: httpMethod,
                            path: path,
                            headers: headers,
                            params: params) {
        case .success(let request): return self.webClient.request(request)
        case .failure(let error): return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private func request<T: Decodable>(httpMethod: HTTPMethod = .get,
                                       path: String,
                                       headers: [String: String]? = nil,
                                       params: [String: String?] = [:]) -> AnyPublisher<WebResult<T>, Error> {
        switch buildRequest(httpMethod: httpMethod,
                            path: path,
                            headers: headers,
                            params: params) {
        case .success(let request): return self.webClient.request(request)
        case .failure(let error): return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
