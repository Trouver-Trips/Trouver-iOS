//
//  HikingFeed.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

struct HikingFeed {
    private(set) var hikes: [HikeInfo] = []
    
    mutating func addHikes(hikes: [HikeInfo]) {
        self.hikes.append(contentsOf: hikes)
    }
    
    mutating func clearHikes() {
        self.hikes.removeAll()
    }
}
