//
//  TrailDetailInfoView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import SwiftUI

struct TrailDetailInfoView: View {
    @ObservedObject var viewModel: TrailDetailViewModel

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ImageCarouselView(images: viewModel.trailImages)
            }
        }
        .navigationTitle("hiking_title")
    }
}

#if DEBUG
struct TrailDetailInfoViewPreviews: PreviewProvider {
    static var previews: some View {
        TrailDetailInfoView(viewModel:
                                TrailDetailViewModel(trailInfo: TrailInfo.sampleData()))
    }
}
#endif
