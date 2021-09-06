//
//  ErrorDTO.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/2/21.
//

import Foundation

struct ErrorDTO: Codable {
    let message: String?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let value, msg, param, location: String?
}
