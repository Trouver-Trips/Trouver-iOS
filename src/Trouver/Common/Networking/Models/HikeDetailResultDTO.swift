//
//  HikeDetailResultDTO.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/18/21.
//

import Foundation

// MARK: - HikeDetail
struct HikeDetailResultDTO: Codable {
    let hike: HikeDetailDTO?
}

// MARK: - Detail
struct HikeDetailDTO: Codable {
    let location: LocationDTO?
    let attributes: [String]?
    let images: [String]?
    let id: String?
    let hikeDescription: String?
    let difficulty: Int?
    let elevationGain, length: Double?
    let name: String?
    let popularity: Double?
    let rating: Double?
    let routeType: String?

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

extension HikeDetailResultDTO: DataFactory {
    static func sampleData() -> HikeDetailResultDTO {
        guard let data = HikeData.hikeDetailData.data(using: .utf8) else {
           preconditionFailure("Could not convert string to data")
        }
        do {
            return try JSONDecoder().decode(HikeDetailResultDTO.self, from: data)
        } catch let error {
            preconditionFailure("Could not decode data: \(error)")
        }
    }
}
