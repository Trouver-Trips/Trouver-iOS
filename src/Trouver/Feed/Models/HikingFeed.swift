//
//  HikingFeed.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

struct HikingFeed {
    var hikes: [HikeInfo] = []
    private var hikeChecker: Set<HikeInfo> = []
    
    func containsHike(_ hike: HikeInfo) -> Bool {
        hikeChecker.contains(hike)
    }
    
    mutating func addHikes(_ hike: HikeInfo, toFront: Bool = false) {
        print("try adding :\(hike.name) does exist: \(hikeChecker.contains(hike))")
        if !hikeChecker.contains(hike) {
            hikeChecker.insert(hike)
            if toFront {
                print("adding :\(hike.name)")
                hikes.insert(hike, at: 0)
            } else {
                hikes.append(hike)
            }
        } else {
            print(hikeChecker.debugDescription)
            print("failed adding :\(hike.name) does exist: \(hikeChecker.contains(hike))")

        }
    }
    
    mutating func addHikes(_ hikes: [HikeInfo]) {
        hikes.forEach { addHikes($0) }
    }
    
    mutating func removeHike(_ hike: HikeInfo) {
        print("remvoing 1:\(hike.name) does exist: \(hikeChecker.contains(hike))")
        hikeChecker.remove(hike)
        hikes.removeAll { $0 == hike }
        print("remvoing 2:\(hike.name) does exist: \(hikeChecker.contains(hike))")
    }
    
    mutating func toggleFavorite(_ hike: HikeInfo) -> HikeInfo {
        if let index = hikes.firstIndex(of: hike) {
            hikes[index].isFavorite = !hikes[index].isFavorite
            return hikes[index]
        }
        return hike
    }
}
