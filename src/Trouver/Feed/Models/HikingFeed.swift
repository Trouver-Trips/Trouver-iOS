//
//  HikingFeed.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

struct HikeInfoSet: Hashable {
    var hikeInfo: HikeInfo
    let timeAdded = Date()
}

struct HikingFeed {
    var hikes = [String: HikeInfoSet]()
    
    mutating func addHikes(_ hike: HikeInfo) {
        hikes[hike.id] = HikeInfoSet(hikeInfo: hike)
    }
    
    mutating func addHikes(_ hikes: [HikeInfo]) {
        hikes.forEach { addHikes($0) }
    }
    
    mutating func removeHike(_ hike: HikeInfo) {
        hikes.removeValue(forKey: hike.id)
    }
}
