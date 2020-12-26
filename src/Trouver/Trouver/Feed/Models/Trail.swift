//
//  Trail.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

// MARK: - TrailResult

struct TrailResult: Codable {
    let trails: [Trail]
    let success: Int
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

// MARK: - Trail

struct Trail: Codable {
    let id: Int
    let name: String
    let type: String
    let summary: String
    let difficulty: String
    let stars: Double
    let starVotes: Int
    let location: String
    let url: String
    let imgSqSmall, imgSmall, imgSmallMed, imgMedium: String
    let length: Double
    let ascent, descent, high, low: Int
    let longitude, latitude: Double
    let conditionStatus: String
    let conditionDetails: String?
    let conditionDate: String
}
