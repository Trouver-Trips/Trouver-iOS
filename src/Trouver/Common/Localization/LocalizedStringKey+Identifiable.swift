//
//  LocalizedStringKey+Identifiable.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import SwiftUI

extension LocalizedStringKey: Identifiable {
    public var id: UUID { UUID() }
}
