//
//  VideoService.swift
//  Space
//
//  Created by Sagar Punhani on 10/3/20.
//

import Foundation

enum ServiceError: Error {
    case decodeError
}

protocol NetworkService {
    /**
     Conduct a search query and return trails
     */
    func fetchTrails(longitude: Double, latitude: Double, page: Int, completion:@escaping Completion<[Trail]>)
    /**
     Prefetch images and download them to a cache to be used whenever
     */
    func prefetch(imageUrls: [String], completion: @escaping ErrorCompletion)
}
