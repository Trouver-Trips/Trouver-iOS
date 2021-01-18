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

    var trailInfo: TrailInfo

    var body: some View {
        VStack {
            Text(trailInfo.name)
                .fontWeight(.bold)
                .font(.title)
            AsyncImage(url: trailInfo.imageUrls[0])
                .clipShape(
                    RoundedRectangle(cornerRadius: cornerRadius)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color("BackgroundColor"), lineWidth: 3)
                )
                .aspectRatio(contentMode: .fit)
        }
        .padding(.horizontal)
    }
}

#if DEBUG
struct HikingFeedItemViewPreviews: PreviewProvider {
    static var previews: some View {
        HikingFeedItemView(trailInfo: TrailInfo.sampleData())
    }
}
#endif
