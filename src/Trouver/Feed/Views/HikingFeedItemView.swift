//
//  HikingFeedItemView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import SwiftUI

struct HikingFeedItemView: View {
    // Private members
    private let cornerRadius: CGFloat = 25

    var hikeInfo: HikeInfo

    var body: some View {
        VStack {
            Text(hikeInfo.name)
                .fontWeight(.bold)
                .font(.title)
            AsyncImage(url: hikeInfo.imageUrls[0])
                .cornerRadius(cornerRadius)
                .shadow(color: Color("BackgroundColor"), radius: 3)
                .aspectRatio(contentMode: .fit)
        }
        .padding(.horizontal)
    }
}

#if DEBUG
struct HikingFeedItemViewPreviews: PreviewProvider {
    static var previews: some View {
        HikingFeedItemView(hikeInfo: HikeInfo.sampleData())
    }
}
#endif
