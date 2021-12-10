//
//  Localization.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/9/21.
//

import Foundation
import SwiftUI

enum Localization {
    static func string(for string: String) -> String {
        NSLocalizedString(string, comment: "")
    }
}
