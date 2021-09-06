//
//  Hike.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

struct Hike: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let imageUrls: [URL]
    let showFavorite: Bool
    var isFavorite: Bool
}

extension Hike {
    init(dto: HikeDTO) {
        self.id = dto.id ?? UUID().uuidString
        self.name = dto.name ?? ""
        self.imageUrls = dto.images?.compactMap { URL(string: $0) } ?? []
        self.showFavorite = dto.favorite != nil
        self.isFavorite = dto.favorite ?? true
    }
}

// MARK: - Sample data

extension Hike: DataFactory {
    static func sampleData() -> Hike {
        Hike(dto: (HikesResultDTO.sampleData().hikes?.docs?.first)!)
    }
}
