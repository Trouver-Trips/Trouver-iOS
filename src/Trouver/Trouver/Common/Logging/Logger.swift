//
//  Logger.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import Foundation

struct Logger {
    static func logInfo(_ message: String) {
        print("Log Info: \(message)")
    }

    static func logError(_ message: String, error: Error? = nil) {
        print("Log Error: \(message), withError: \(error?.localizedDescription ?? "none")")
    }
}
