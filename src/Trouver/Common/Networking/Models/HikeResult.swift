//
//  HikeResult.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

// MARK: - HikeResult

struct HikeResult: Codable {
    let message: String
    let hikes: Hikes
}

// MARK: - Hikes
struct Hikes: Codable {
    let docs: [HikeDoc]
    let totalDocs, limit, totalPages, page: Int
    let pagingCounter: Int
    let hasPrevPage, hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int?
}

// MARK: - Doc
struct HikeDoc: Codable, Hashable {
    static func == (lhs: HikeDoc, rhs: HikeDoc) -> Bool {
        lhs.id == rhs.id
    }
    
    let location: Location
    let images: [String]
    let id: String
    let difficulty: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case location, images
        case id = "_id"
        case difficulty, name
    }
}

// MARK: - Location
struct Location: Codable, Hashable {
    let coordinates: [Double]
}

// MARK: - Sample Data
extension HikeResult: DataFactory {
    static func sampleData() -> HikeResult {
        guard let data = HikeData.hikeInfo.data(using: .utf8) else {
           preconditionFailure("Could not convert string to data")
        }
        do {
            return try JSONDecoder().decode(HikeResult.self, from: data)
        } catch let error {
            preconditionFailure("Could not decode data: \(error)")
        }
    }
}
