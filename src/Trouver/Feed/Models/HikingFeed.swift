//
//  HikingFeed.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

struct HikeSet: Hashable {
    var hike: Hike
    let timeAdded = Date()
}

struct HikingFeed {
    var hikes = [String: HikeSet]()
    
    mutating func addHikes(_ hike: Hike) {
        hikes[hike.id] = HikeSet(hike: hike)
    }
    
    mutating func addHikes(_ hikes: [Hike]) {
        hikes.forEach { addHikes($0) }
    }
    
    mutating func removeHike(_ hike: Hike) {
        hikes.removeValue(forKey: hike.id)
    }
}
