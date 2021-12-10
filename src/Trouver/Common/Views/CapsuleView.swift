//
//  CapsuleView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/9/21.
//

import SwiftUI

struct CapsuleView: View {
    let text: LocalizedStringKey
    let color: Color
    
    var body: some View {
        Text(text)
            .foregroundColor(color)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(self.color, lineWidth: 4)
            )
    }
}

#if DEBUG
struct CapsuleViewPreviews: PreviewProvider {
    static var previews: some View {
        CapsuleView(text: "Hello", color: .green)
    }
}
#endif
