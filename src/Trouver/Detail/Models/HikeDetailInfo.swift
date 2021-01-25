//
//  HikeDetailInfo.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/18/21.
//

import Foundation

// Model for Hiking Details
struct HikeDetailInfo {
    private let hikeDetail: DetailDoc

    init(hikeDetail: DetailDoc) {
        self.hikeDetail = hikeDetail
    }

    // MARK: - Public properties

    var id: String { hikeDetail.id }
    var name: String { hikeDetail.name }
    var imageUrls: [URL] {
        hikeDetail.images.compactMap { URL(string: $0) }
    }
    var attrributes: [String] {
        hikeDetail.attributes
    }
}
