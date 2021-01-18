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
                Text(viewModel.name)
                    .fontWeight(.bold)
                    .font(.system(.largeTitle, design: .rounded))
                    .padding()
                ImageCarouselView(images: viewModel.trailImages)
                    .frame(height: UIScreen.main.bounds.width * 3.0/4.0)
            }
        }
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
