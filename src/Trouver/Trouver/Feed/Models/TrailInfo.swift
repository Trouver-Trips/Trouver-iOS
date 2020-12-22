//
//  TrailInfo.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

struct TrailInfo {
    private(set) var trails: [Trail]

    static func createEmptyTrails() -> TrailInfo {
        return TrailInfo(trails: [])
    }

    mutating func updateTrails(trails: [Trail]) {
        self.trails = trails
    }
}
