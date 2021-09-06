//
//  IconLabel.swift
//  Trouver
//
//  Created by Sagar Punhani on 9/6/21.
//

import SwiftUI

struct IconLabel: View {
    let image: String
    let key: LocalizedStringKey
    
    var body: some View {
        HStack {
            Image(systemName: image)
            Text(key)
        }
    }
}

#if DEBUG
struct IconLabelPreviews: PreviewProvider {
    static var previews: some View {
        IconLabel(image: "triangle", key: "trouver.title")
    }
}
#endif
