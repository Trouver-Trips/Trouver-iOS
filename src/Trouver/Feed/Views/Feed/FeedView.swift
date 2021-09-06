//
//  FeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/29/21.
//

import SwiftUI

struct FeedView: View {
    private enum Constants {
        static let gridSpacing: CGFloat = 4
        static let minImageHeight: CGFloat = 150
        static let topMargin: CGFloat = -48
    }
        
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @ObservedObject var viewModel: FeedCoordinator
    @Binding var showingDetail: Bool

    var body: some View {
        switch viewModel.viewState {
        case .error: Text("Error loading hikes")
        case .loaded, .loading:
            NavigationView {
                VStack {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.hikes) { hike in
                                NavigationLink(destination:
                                                DetailView(isPresented: $showingDetail,
                                                           viewModel: viewModel(for: hike))) {
                                    FeedItemView(imageUrl: hike.imageUrls[0])
                                        .padding(Constants.gridSpacing)
                                        .onAppear {
                                            viewModel.loadMoreContentIfNeeded(hike: hike)
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
        
    private func viewModel(for hike: Hike) -> HikeDetailProvider {
        .init(hike: hike,
              favoritesCoordinator: viewModel.favoritesCoordinator,
              networkService: viewModel.networkService)
    }
}

struct GridFeedViewPreviews: PreviewProvider {
    static var previews: some View {
        FeedView(viewModel: .init(feedType: .newsfeed, favoritesCoordinator: FavoritesCoordinator()),
                 showingDetail: .constant(false))
    }
}
