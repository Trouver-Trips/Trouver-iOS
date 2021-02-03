//
//  ErrorResult.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/2/21.
//

import Foundation

struct ErrorResult: Codable {
    let message: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let value, msg, param, location: String
}
