//
//  SegmentView.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import SwiftUI

struct SegmentView: View {
    let text: LocalizedStringKey
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .foregroundColor(isSelected ? Color.accentColor : Color.systemGray3)
                .padding(.vertical, 6)
            Spacer()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.accentColor : Color.systemGray3, lineWidth: 2)
        )
    }
}

#if DEBUG
struct SegmentViewPreviews: PreviewProvider {
    
    static var previews: some View {
        SegmentView(text: "sort.option.popular", isSelected: true)
    }
}
#endif
