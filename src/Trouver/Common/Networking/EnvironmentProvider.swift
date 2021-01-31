//
//  EnvironmentProvider.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/17/21.
//

import Foundation

struct EnvironmentProvider {
    static var host: String {
        #if DEBUG
        return "cold-liger-16.loca.lt"
        #else
        return "www.trouvertrips.com"
        #endif
    }
}
