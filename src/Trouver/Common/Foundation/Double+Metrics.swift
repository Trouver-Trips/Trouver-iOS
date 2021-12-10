//
//  Double+Metrics.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/9/21.
//

import Foundation

extension Double {
    static var feetPerMile: Double { 5280 }
    
    var toFeet: Double { self * 3.28084 }
    
    var toMiles: Double { self * 0.000621371 }
}
