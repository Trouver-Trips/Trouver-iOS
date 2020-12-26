//
//  TrailInfoView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import SwiftUI

struct TrailDetailInfoView: View {
    @ObservedObject var trailInfo: TrailDetailViewModel

    var body: some View {
        if trailInfo.images.isEmpty {
            Image("Placeholder")
                .resizable()
                .scaledToFit()
        } else {
            ScrollView(.vertical) {
                VStack {
                    TabView {
                        ForEach(trailInfo.images, id: \.self) { image in
                        Image(uiImage: image)
                          .resizable()
                          .frame(maxWidth: 500, maxHeight: 300)
                          .scaledToFill()
                      }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .fixedSize()
                    Text(trailInfo.name)
                }
            }
            .navigationTitle("Hiking")
        }
    }
}

#if DEBUG
struct TrailInfoViewPreviews: PreviewProvider {
    static var previews: some View {
        TrailDetailInfoView(trailInfo: TrailDetailViewModel(trail: HikingFeedViewModel().trails[0]))
    }
}
#endif
