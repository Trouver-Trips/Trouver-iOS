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
        return "shy-donkey-15.loca.lt"
        #else
        return "www.trouvertrips.com"
        #endif
    }
}
