//
//  FeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/19/20.
//

import SwiftUI

struct HikingFeedView: View {
    @ObservedObject var viewModel: HikingFeedViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.trails) { trailInfo in
                        NavigationLink(destination:
                                        TrailDetailInfoView(viewModel: TrailDetailViewModel(trailInfo: trailInfo))) {
                            HikingFeedItemView(trailInfo: trailInfo)
                                .listRowInsets(EdgeInsets())
                                .padding(.vertical, 10)
                        }
                        .buttonStyle(FlatLinkStyle())
                    }
                }
            }
            .navigationBarTitle("trouver_title")
        }
    }
}

#if DEBUG
struct FeedViewPreviews: PreviewProvider {
    static var previews: some View {
        HikingFeedView(viewModel: HikingFeedViewModel())
    }
}
#endif
