//
//  FeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/29/21.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel: FeedCoordinator
    @Binding var showingDetail: Bool

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
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.hikes) { hikeInfo in
                                NavigationLink(destination:
                                                DetailView(isPresented: $showingDetail,
                                                           viewModel: viewModel(for: hikeInfo))) {
                                    FeedItemView(imageUrl: hikeInfo.imageUrls[0])
                                        .padding(Constants.gridSpacing)
                                        .onAppear {
                                            viewModel.loadMoreContentIfNeeded(item: hikeInfo)
                                        }
                                }
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
                   favoritesCoordinator: viewModel.favoritesCoordinator,
                   networkService: viewModel.networkService)
    }
}

struct GridFeedViewPreviews: PreviewProvider {
    static var previews: some View {
        FeedView(viewModel:
                        FeedCoordinator(feedType: .newsfeed,
                                        favoritesCoordinator: FavoritesCoordinator()),
                     showingDetail: .constant(false))
    }
}
