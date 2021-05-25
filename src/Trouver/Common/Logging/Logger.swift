//
//  Logger.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

struct Logger {
    enum Level: Int {
        case none = 0
        case debug = 1
        case verbose = 2
    }
    
    static var currentLevel: Level = .debug
    
    static func logInfo(_ message: String, level: Level = .debug) {
        if level.rawValue <= currentLevel.rawValue {
            print("Log Info: \(message)")
        }
    }

    static func logError(_ message: String, error: Error? = nil, level: Level = .debug) {
        if let error = error {
            print("Log Error: \(message), withError: \(error)")
        } else {
            print("Log Error: \(message)")
        }
    }
}
