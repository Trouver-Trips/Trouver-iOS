//
//  HttpWebClient.swift
//  Trouver
//
//  Created by Sagar Punhani on 9/30/20.
//

import Foundation

typealias Completion<T> = (Result<T, Error>) -> Void
typealias ErrorCompletion = (Error?) -> Void

enum NetworkingError: Error {
    case invalidUrl
    case decodeError
    case failedHttpResponse(code: Int)
}

protocol WebClient {
    /**
     Get request that returns a codable model
     */
    func getRequest<T: Decodable>(path: String, params: [String: String?], completion: @escaping Completion<T>)

    /**
     Download data into a cache ahead of time
     */
    func prefetch(data: [URL], completion: @escaping ErrorCompletion)
}
