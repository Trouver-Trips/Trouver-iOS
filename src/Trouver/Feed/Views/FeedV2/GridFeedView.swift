//
//  GridFeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/29/21.
//

import SwiftUI
import WaterfallGrid

struct GridFeedView: View {
    @ObservedObject var viewModel: FeedCoordinator
    @AppStorage("useLazyGrid") var useLazyGrid = false

    private struct Constants {
        static let gridSpacing: CGFloat = 4
        static let minImageHeight: CGFloat = 150
    }
        
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        switch viewModel.viewState {
        case .error: Text("Error loading hikes")
        case .loaded, .loading:
            if useLazyGrid {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.hikes) { hikeInfo in
                            LazyGridFeedItemView(imageUrl: hikeInfo.imageUrls[0])
                                .padding(Constants.gridSpacing)
                                .onAppear {
                                    viewModel.loadMoreContentIfNeeded(item: hikeInfo)
                                }
                        }
                    }
                }
                .padding()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    WaterfallGrid(viewModel.hikes) { hikeInfo in
                        GridFeedItemView(imageUrl: hikeInfo.imageUrls[0])
                            .padding(Constants.gridSpacing)
                    }
                    .gridStyle(columns: 2)
                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .named("scroll")).minY
                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                    }
                    ProgressView()
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    if value < 750 {
                        viewModel.loadMoreContentIfNeeded()
                    }
                }
                .padding()
            }
        }
    }
}

struct GridFeedViewPreviews: PreviewProvider {
    static var previews: some View {
        GridFeedView(viewModel: FeedCoordinator(feedType: .newsfeed, favoritesCoordinator: FavoritesCoordinator()))
    }
}
