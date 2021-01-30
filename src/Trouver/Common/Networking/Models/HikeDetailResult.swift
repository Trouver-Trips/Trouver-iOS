//
//  HikeDetailResult.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/18/21.
//

import Foundation

// MARK: - HikeDetail
struct HikeDetailResult: Codable {
    let hike: DetailDoc
}

// MARK: - Detail
struct DetailDoc: Codable {
    let location: Location
    let attributes: [String]
    let images: [String]
    let id, hikeDescription: String
    let difficulty: Int
    let elevationGain, length: Double
    let name: String
    let popularity: Double
    let rating: Double
    let routeType: String

    enum CodingKeys: String, CodingKey {
        case location, attributes, images
        case id = "_id"
        case hikeDescription = "description"
        case difficulty
        case elevationGain = "elevation_gain"
        case length, name, popularity, rating
        case routeType = "route_type"
    }
}
