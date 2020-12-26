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
    private let trail: Trail

    init(trail: Trail) {
        self.trail = trail
    }

    // MARK: - Public properties

    var id: Int { return trail.id }
    var name: String { return trail.name }
    var imageUrls: [URL] {
        var urlStrings = [String]()
        urlStrings.append(self.trail.imgMedium)
        urlStrings.append(self.trail.imgMedium)
        urlStrings.append(self.trail.imgMedium)
        urlStrings.append(self.trail.imgMedium)
        return urlStrings.compactMap { URL(string: $0) }
    }
}

// MARK: - Sample data

extension TrailInfo: DataFactory {
    static func sampleData() -> TrailInfo {
        TrailInfo(trail: TrailResult.sampleData().trails[0])
    }
}
