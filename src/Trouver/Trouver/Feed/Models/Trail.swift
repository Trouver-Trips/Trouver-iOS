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

// MARK: - Trail
// swiftlint:disable identifier_name
struct Trail: Codable, Identifiable {
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
    let conditionDetails: String
    let conditionDate: String
}
// swiftlint:enable identifier_name
