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
     
    var body: some View {
        Image(systemName: systemIconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .padding(.horizontal, 20)
            .foregroundColor(isHighlighted ?
                                Color("TabBarHighlight") : Color("TabBarDisabled"))
    }
}

struct TabBarItemPreviews: PreviewProvider {
    static var previews: some View {
        TabBarItem(systemIconName: "heart", isHighlighted: true)
    }
}
