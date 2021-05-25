//
//  TabBarItem.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/30/21.
//

import SwiftUI

struct TabBarItem: View {
    let systemIconName: String
    let isHighlighted: Bool
    let size: CGFloat
    let padding: CGFloat
    
    init(systemIconName: String,
         isHighlighted: Bool,
         size: CGFloat = 30,
         padding: CGFloat = 20) {
        self.systemIconName = systemIconName
        self.isHighlighted = isHighlighted
        self.size = size
        self.padding = padding
    }
     
    var body: some View {
        Image(systemName: systemIconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size,
                   height: size)
            .padding(.horizontal, padding)
            .foregroundColor(isHighlighted ?
                                Color("TabBarHighlight") : Color("TabBarDisabled"))
    }
}

struct TabBarItemPreviews: PreviewProvider {
    static var previews: some View {
        TabBarItem(systemIconName: "heart", isHighlighted: true)
    }
}
