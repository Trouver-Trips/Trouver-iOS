//
//  EnvironmentProvider.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/17/21.
//

import Foundation

struct EnvironmentProvider {
    static var currEnv: Environment = .production
    
    enum Environment {
        case development
        case production
    }
    
    static var host: String {
        switch currEnv {
        case .development: return "gentle-kangaroo-36.loca.lt"
        case .production: return "trouver-1609617930729.wl.r.appspot.com"
        }
    }
}
