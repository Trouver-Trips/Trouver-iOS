//
//  HikeDetail.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/18/21.
//

import Foundation
import CoreGraphics

// Model for Hiking Details
struct HikeDetail {
    let id: String
    let name: String
    let imageUrls: [URL]
    let attributes: [String]
    let description: String
    let rating: CGFloat
    let location: Location
    let difficulty: Difficulty
    let elevationGain: Double
    let length: Double
    let popularity: Double
    let routeType: RouteType
}

extension HikeDetail {
    init(dto: HikeDetailDTO) {
        self.id = dto.id ?? UUID().uuidString
        self.name = dto.name ?? "No name found"
        self.imageUrls = dto.images?.compactMap { URL(string: $0) } ?? []
        self.attributes = dto.attributes ?? []
        self.description = dto.hikeDescription ?? "No description found"
        self.rating = CGFloat(dto.rating ?? 0)
        self.location = dto.location.map { Location(dto: $0) } ?? .init(coordinates: [])
        self.difficulty = Difficulty(from: dto.difficulty ?? 0)
        self.elevationGain = dto.elevationGain ?? 0
        self.length = dto.length ?? 0
        self.popularity = dto.popularity ?? 0
        self.routeType = RouteType(rawValue: dto.routeType ?? "") ?? .unknown
    }
}

struct Location {
    let coordinates: [Double]
}

extension Location {
    init(dto: LocationDTO) {
        self.coordinates = dto.coordinates ?? []
    }
}

enum RouteType: String {
    case outAndBack = "O"
    case loop = "L"
    case unknown = "U"
}
