//
//  Hike.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

// MARK: - TrailResult

struct TrailResult: Codable {
    let message: String
    let hikes: Hikes
}

// MARK: - Sample Data

extension TrailResult: DataFactory {
    static func sampleData() -> TrailResult {
        guard let data = TrailData.trailData.data(using: .utf8) else {
           preconditionFailure("Could not convert string to data")
        }
        do {
            return try JSONDecoder().decode(TrailResult.self, from: data)
        } catch let error {
            preconditionFailure("Could not decode data: \(error)")
        }
    }
}

// MARK: - Hikes
struct Hikes: Codable {
    let docs: [Doc]
    let totalDocs, limit, totalPages, page: Int
    let pagingCounter: Int
    let hasPrevPage, hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int
}

// MARK: - Doc
struct Doc: Codable {
    let location: Location
    let images: [String]
    let id: String
    let trailID, difficulty: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case location, images
        case id = "_id"
        case trailID = "trailId"
        case difficulty, name
    }
}

// MARK: - Location
struct Location: Codable {
    let coordinates: [Double]
}
