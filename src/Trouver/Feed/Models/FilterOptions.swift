//
//  FilterOptions.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import Foundation

struct FilterOptions {
    var sort: SortType = .closest
    var difficulty: [Difficulty] = []
    var lengthMin: Int = 0
    var lengthMax: Int = Int.max
    var elevationMin: Int = 0
    var elevationMax: Int = Int.max
}
