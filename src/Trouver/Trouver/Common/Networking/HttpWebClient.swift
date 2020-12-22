//
//  HttpWebClient.swift
//  Trouver
//
//  Created by Sagar Punhani on 10/4/20.
//

import Foundation
import Alamofire
import AlamofireImage

class HTTPWebClient {
    private let downloader: ImageDownloader
    private var baseUrlComponent: URLComponents
    private var request: DataRequest?

    init(host: String) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        self.baseUrlComponent = components
        self.downloader = ImageDownloader()
    }
}

extension HTTPWebClient: WebClient {
    func getRequest<T: Decodable>(path: String, params: [String: String?], completion: @escaping Completion<T>) {
        baseUrlComponent.path = path
        self.request?.cancel()

        guard let url = baseUrlComponent.url else {
            completion(.failure(NetworkingError.invalidUrl))
            return
        }

        self.request = AF.request(url, parameters: params)
            .validate()
            .responseDecodable(of: T.self) { response in
                self.request = nil
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                guard let model = response.value else {
                    completion(.failure(NetworkingError.decodeError))
                    return
                }
                completion(.success(model))
            }
    }

    func prefetch(data: [URL], completion: @escaping ErrorCompletion) {
        let requests = data.compactMap { URLRequest(url: $0) }
        downloader.download(requests, completion: { response in
            completion(response.error)
        })
    }
}
