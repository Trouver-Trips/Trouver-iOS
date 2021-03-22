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
        
        return request(httpMethod: .post, path: APIPath.login.rawValue, headers: headers)
    }

    func fetchHikes(latitude: Double,
                    longitude: Double,
                    page: Int) -> AnyPublisher<HikeResult, Error> {
        let params = [
            "lat": latitude.description,
            "long": longitude.description,
            "page": page.description,
            "trouverId": accountHandle.user.trouverId
        ]

        return request(path: APIPath.feed.rawValue, params: params)
    }

    func getHikeDetail(hikeId: String) -> AnyPublisher<HikeDetailResult, Error> {
        request(path: APIPath.hikeDetail.addHikeId(hikeId))
    }
    
    func updateFavorite(hikeId: String, addHike: Bool) -> AnyPublisher<FavoriteActionResult, Error> {
        let httpMethod: HTTPMethod = addHike ? .post : .delete
        let path = APIPath.users.addFavoriteId(accountHandle.user.trouverId)
        let params = [
            "hikeId": hikeId
        ]
        
        return request(httpMethod: httpMethod, path: path, params: params)
    }
    
    func fetchFavorites(page: Int) -> AnyPublisher<FavoritesResult, Error> {
        let path = APIPath.users.addFavoriteId(accountHandle.user.trouverId)
        let params = [
            "page": page.description
        ]
        
        return request(path: path, params: params)
    }
    
    private func refreshToken() -> AnyPublisher<TokenRefreshResult, Error> {
        let headers = [
            "Authorization": accountHandle.user.accessToken,
            "x-Refresh-Token": accountHandle.user.refreshToken
        ]
        let params = [
            "trouverId": accountHandle.user.trouverId
        ]
        print(headers.debugDescription)
        print(params.debugDescription)
        return request(path: APIPath.refresh.rawValue, headers: headers, params: params)
    }
    
    private func request<T: Decodable>(httpMethod: HTTPMethod = .get,
                                       path: String,
                                       headers: [String: String]? = nil,
                                       params: [String: String?] = [:]) -> AnyPublisher<WebResult<T>, Error> {
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
        
        // Do not refresh for itself or login
        if accountHandle.hasExpired && !path.contains("refresh") && !path.contains("login") {
            return refreshToken()
                .handleEvents(
                    receiveOutput: {
                        if let token = $0.token {
                            self.accountHandle.updateToken(token)
                        }
                    }
                )
                .flatMap { _ -> AnyPublisher<WebResult<T>, Error> in
                    self.webClient.request(request).eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
        
        return webClient.request(request)
    }
    
    private func request<T: Decodable>(httpMethod: HTTPMethod = .get,
                                       path: String,
                                       headers: [String: String]? = nil,
                                       params: [String: String?] = [:]) -> AnyPublisher<T, Error> {
        let publisher: AnyPublisher<WebResult<T>, Error> = request(httpMethod: httpMethod,
                                                                        path: path,
                                                                        headers: headers,
                                                                        params: params)
        return publisher
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
