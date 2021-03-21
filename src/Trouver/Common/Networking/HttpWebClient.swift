//
//  HttpWebClient.swift
//  Trouver
//
//  Created by Sagar Punhani on 10/4/20.
//

import Combine
import Foundation

struct WebResult<T: Decodable> {
    let data: T
    let headers: [String: Any]
}

protocol WebClient {
    
    /**
     Request that returns a publisher with Info
     */
    func request<T: Decodable>(_ request: URLRequest) -> AnyPublisher<WebResult<T>, Error>
}

struct HttpWebClient: WebClient {
    func request<T>(_ request: URLRequest) -> AnyPublisher<WebResult<T>, Error> where T: Decodable {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .handleEvents(
                receiveOutput: { Logger.logInfo(String(data: $0.data, encoding: .utf8) ?? "Could not decode output", level: .verbose) }
            )
            .tryMap {
                if let response = $0.response as? HTTPURLResponse,
                   let headers = response.allHeaderFields as? [String: Any],
                   let jsonObject = try? JSONDecoder().decode(T.self, from: $0.data) {
                    return WebResult(data: jsonObject, headers: headers)
                } else {
                    throw NetworkError.badOutput
                }
            }
            .eraseToAnyPublisher()
    }
}
