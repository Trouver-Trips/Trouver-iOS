//
//  TrailItemView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import SwiftUI

struct HikingFeedItemView: View {
    @ObservedObject var trailInfo: TrailDetailViewModel

    var body: some View {
        VStack {
            Text(trailInfo.name)
            ImageCarouselView(images: trailInfo.images)
        }
    }
}

#if DEBUG
struct TrailItemViewPreviews: PreviewProvider {
    static var previews: some View {
        HikingFeedItemView(trailInfo: TrailDetailViewModel(trail: HikingFeedViewModel().trails[0]))
    }
}
#endif
