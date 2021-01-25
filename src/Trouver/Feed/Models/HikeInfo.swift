//
//  HikeInfo.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation
/*
 Wrapper around Hike object
 */
struct HikeInfo: Identifiable {
    private let hike: HikeDoc

    init(hike: HikeDoc) {
        self.hike = hike
    }

    // MARK: - Public properties

    var id: String { hike.id }
    var name: String { hike.name }
    var imageUrls: [URL] {
        hike.images.compactMap { URL(string: $0) }
    }
}

// MARK: - Sample data

extension HikeInfo: DataFactory {
    static func sampleData() -> HikeInfo {
        HikeInfo(hike: HikeResult.sampleData().hikes.docs[0])
    }
}
