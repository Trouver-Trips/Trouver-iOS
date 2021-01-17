//
//  HikingFeedItemView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import SwiftUI

struct HikingFeedItemView: View {
    var trailInfo: TrailInfo

    var body: some View {
        VStack {
            Text(trailInfo.name)
            ImageCarouselView(images: trailInfo.imageUrls)
        }
    }
}

#if DEBUG
struct HikingFeedItemViewPreviews: PreviewProvider {
    static var previews: some View {
        HikingFeedItemView(trailInfo: TrailInfo.sampleData())
    }
}
#endif
