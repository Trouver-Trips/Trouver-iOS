//
//  FlatButtonStyle.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/25/20.
//

import SwiftUI

/*
 Ignore style when clicking on navigation items
 */
struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
