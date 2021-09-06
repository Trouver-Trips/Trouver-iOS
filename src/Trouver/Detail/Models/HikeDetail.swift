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
    private let prepositions: Set<String> = [
        "in",
        "via",
        "to",
        "from",
        "at",
        "via",
        "&"
    ]
    
    let id: String
    let name: String
    let imageUrls: [URL]
    let attributes: [String]
    let description: String
    let rating: CGFloat
    let location: Location
    let difficulty: Difficulty
    let elevationGain: Int
    let length: Double
    let popularity: Double
    let routeType: RouteType
    
    var shortName: String {
        var comps = self.name.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }[..<3]
            
        if let deleteIndex = comps.firstIndex(where: { prepositions.contains($0) }) {
            comps = comps[0..<deleteIndex]
        }
        
        if let deleteIndex = comps.firstIndex(where: { $0.contains(",") }) {
            comps[deleteIndex].removeAll { $0 == "," }
            comps = comps[0...deleteIndex]
        }
        
        return comps.joined(separator: " ")
    }
}

extension HikeDetail {
    init(dto: HikeDetailDTO) {
        self.id = dto.id ?? UUID().uuidString
        self.name = dto.name ?? Localization.string(for: "hike.unknown.title")
        self.imageUrls = dto.images?.compactMap { URL(string: $0) } ?? []
        self.attributes = dto.attributes ?? []
        self.description = dto.hikeDescription ?? Localization.string(for: "description.unknown.title")
        self.rating = CGFloat(dto.rating ?? 0)
        self.location = dto.location.map { Location(dto: $0) } ?? .init(coordinates: [])
        self.difficulty = Difficulty(from: dto.difficulty ?? 0)
        self.elevationGain = Int((dto.elevationGain ?? 0).toFeet)
        self.length = (dto.length ?? 0).toMiles
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
