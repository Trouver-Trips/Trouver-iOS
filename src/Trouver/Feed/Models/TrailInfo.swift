//
//  TrailInfo.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation
/*
 Wrapper around Trail object
 */
struct TrailInfo: Identifiable {
    private let trail: Doc

    init(trail: Doc) {
        self.trail = trail
    }

    // MARK: - Public properties

    var id: Int { trail.trailID }
    var name: String { trail.name }
    var imageUrls: [URL] {
        trail.images.compactMap { URL(string: $0) }
    }
}

// MARK: - Sample data

extension TrailInfo: DataFactory {
    static func sampleData() -> TrailInfo {
        TrailInfo(trail: TrailResult.sampleData().hikes.docs[0])
    }
}
