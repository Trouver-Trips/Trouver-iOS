//
//  HikesResultDTO.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

// MARK: - HikeResult

struct HikesResultDTO: Codable {
    let message: String?
    let hikes: HikesDTO?
}

// MARK: - Hikes
struct HikesDTO: Codable {
    let docs: [HikeDTO]?
    let totalDocs, limit, totalPages, page: Int?
    let pagingCounter: Int?
    let hasPrevPage, hasNextPage: Bool?
    let prevPage: Int?
    let nextPage: Int?
}

// MARK: - Doc
struct HikeDTO: Codable, Hashable {
    static func == (lhs: HikeDTO, rhs: HikeDTO) -> Bool {
        lhs.id == rhs.id
    }
    
    let location: LocationDTO?
    let images: [String]?
    let id: String?
    let difficulty: Int?
    let name: String?
    let favorite: Bool?

    enum CodingKeys: String, CodingKey {
        case location, images
        case id = "_id"
        case difficulty, name, favorite
    }
}

// MARK: - Location
struct LocationDTO: Codable, Hashable {
    let coordinates: [Double]?
}

// MARK: - Sample Data
extension HikesResultDTO: DataFactory {
    static func sampleData() -> HikesResultDTO {
        guard let data = HikeData.hikeData.data(using: .utf8) else {
           preconditionFailure("Could not convert string to data")
        }
        do {
            return try JSONDecoder().decode(HikesResultDTO.self, from: data)
        } catch let error {
            preconditionFailure("Could not decode data: \(error)")
        }
    }
}
