//
//  PillView.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/24/21.
//

import SwiftUI

struct PillView: View {
    let text: String

    var body: some View {
        Text(text)
            .padding()
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.green, lineWidth: 2)
            )
    }
}

struct PillViewPreviews: PreviewProvider {
    static var previews: some View {
        PillView(text: "Mountain")
    }
}
