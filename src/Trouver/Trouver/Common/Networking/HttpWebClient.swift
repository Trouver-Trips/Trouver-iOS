//
//  HttpWebClient.swift
//  Trouver
//
//  Created by Sagar Punhani on 10/4/20.
//

import Combine
import Foundation

protocol WebClient {
    /**
     Request that returns a publisher
     */
    func request<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error>
}

struct HttpWebClient: WebClient {
    func request<T>(_ request: URLRequest) -> AnyPublisher<T, Error> where T: Decodable {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .handleEvents(
                receiveOutput: { Logger.logInfo(String(data: $0, encoding: .utf8) ?? "Could not decode output" )}
            )
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
