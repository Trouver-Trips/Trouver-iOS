//
//  Environment.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/17/21.
//

import Foundation

struct EnvironmentProvider {
    static var host: String {
        #if DEBUG
        return "angry-insect-93.loca.lt"
        #else
        return "angry-inset-93.loca.lt"
        #endif
    }
}
