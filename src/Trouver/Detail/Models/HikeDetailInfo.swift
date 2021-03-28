//
//  HikeDetailInfo.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/18/21.
//

import Foundation
import CoreGraphics

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
    var attributes: [String] { hikeDetail.attributes }
    var description: String { hikeDetail.hikeDescription ?? "No description found" }
    var rating: CGFloat { CGFloat(hikeDetail.rating) }
    var location: Location { hikeDetail.location }
    var difficulty: Difficulty { Difficulty(rawValue: hikeDetail.difficulty) ?? .unknown }
    var elevationGain: Double { hikeDetail.elevationGain }
    var length: Double { hikeDetail.length }
    var popularity: Double { hikeDetail.length }
    var routeType: RouteType {
        RouteType(rawValue: hikeDetail.routeType) ?? .unknown
    }
}

enum RouteType: String {
    case outAndBack = "O"
    case loop = "L"
    case unknown = "U"
}
