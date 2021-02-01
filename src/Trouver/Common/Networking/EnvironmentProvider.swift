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
        return "sour-parrot-75.loca.lt"
        #else
        return "www.trouvertrips.com"
        #endif
    }
}
