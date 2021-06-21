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
    @Binding var showingDetail: Bool
    @AppStorage("useLazyGrid") private var useLazyGrid = true

    private enum Constants {
        static let gridSpacing: CGFloat = 4
        static let minImageHeight: CGFloat = 150
        static let topMargin: CGFloat = -48
    }
        
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        switch viewModel.viewState {
        case .error: Text("Error loading hikes")
        case .loaded, .loading:
            NavigationView {
                VStack {
                    if useLazyGrid {
                        ScrollView {
                            LazyVGrid(columns: columns) {
                                ForEach(viewModel.hikes) { hikeInfo in
                                    NavigationLink(destination:
                                                    DetailView(isPresented: $showingDetail,
                                                               viewModel: viewModel(for: hikeInfo))) {
                                        LazyGridFeedItemView(imageUrl: hikeInfo.imageUrls[0])
                                            .padding(Constants.gridSpacing)
                                            .onAppear {
                                                viewModel.loadMoreContentIfNeeded(item: hikeInfo)
                                            }
                                    }
                                }
                            }
                        }
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            WaterfallGrid(viewModel.hikes) { hikeInfo in
                                NavigationLink(destination:
                                                DetailView(isPresented: $showingDetail,
                                                           viewModel: viewModel(for: hikeInfo))) {
                                    GridFeedItemView(imageUrl: hikeInfo.imageUrls[0])
                                        .padding(Constants.gridSpacing)
                                }
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
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .searchView { location in
                    viewModel.search(location: location)
                }
                .padding(.horizontal)
            }
            .padding(.top, Constants.topMargin)
        }
    }
        
    private func viewModel(for hikeInfo: HikeInfo) -> HikeDetail {
        HikeDetail(hikeInfo: hikeInfo,
                   networkService: viewModel.networkService)
    }
}

struct GridFeedViewPreviews: PreviewProvider {
    static var previews: some View {
        GridFeedView(viewModel:
                        FeedCoordinator(feedType: .newsfeed,
                                        favoritesCoordinator: FavoritesCoordinator()),
                     showingDetail: .constant(false))
    }
}
