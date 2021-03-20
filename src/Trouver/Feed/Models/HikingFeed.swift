//
//  HikingFeed.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

struct HikingFeed {
    private(set) var hikes: [HikeInfo] = []
    private var hikeChecker: Set<HikeInfo> = []
    
    func containsHike(_ hike: HikeInfo) -> Bool {
        hikeChecker.contains(hike)
    }
    
    mutating func addHikes(_ hike: HikeInfo) {
        if !hikeChecker.contains(hike) {
            self.hikeChecker.insert(hike)
            self.hikes.append(hike)
        }
    }
    
    mutating func addHikes(_ hikes: [HikeInfo]) {
        hikes.forEach { addHikes($0) }
    }
    
    mutating func removeHike(_ hike: HikeInfo) {
        self.hikeChecker.remove(hike)
        self.hikes.removeAll { $0 == hike }
    }
    
    mutating func updateHike(_ hike: HikeInfo) {
        if let index = self.hikes.firstIndex(of: hike) {
            self.hikes[index] = hike
        }
    }
    
    mutating func clearHikes() {
        self.hikeChecker.removeAll()
        self.hikes.removeAll()
    }
}
