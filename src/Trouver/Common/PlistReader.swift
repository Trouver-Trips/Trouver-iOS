//
//  PlistReader.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/20/21.
//

import Foundation

struct PlistReader {
    static func read(key: String, for plist: String = "APIKeys") -> String? {
        if let fileUrl = Bundle.main.url(forResource: plist, withExtension: "plist"),
           let data = try? Data(contentsOf: fileUrl),
           let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)
            as? [String: String] {
            return result[key]
        }
        return nil
    }
}
