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
        CapsuleView(text: text, color: isSelected ? .accentColor : .systemGray3)
    }
}

#if DEBUG
struct SegmentViewPreviews: PreviewProvider {
    
    static var previews: some View {
        SegmentView(text: "sort.option.popular", isSelected: true)
    }
}
#endif
