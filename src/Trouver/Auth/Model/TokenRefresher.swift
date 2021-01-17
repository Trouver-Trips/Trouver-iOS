//
//  TokenRefresher.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import Combine

enum TokenError: Error {
     case nilToken
}

protocol TokenRefresher {
    var refreshToken: Future<String, Error> { get }
}
