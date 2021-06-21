//
//  FavoriteFeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 6/20/21.
//

import SwiftUI

struct FavoriteFeedView: View {
    @ObservedObject var viewModel: FeedCoordinator
    @Binding var showingDetail: Bool

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    Text("favorites.title")
                        .font(.largeTitle)
                        .padding()
                    ForEach(viewModel.hikes) { hike in
                        FavoriteFeedItemView(hikeInfo: hike,
                                             favoritesCoordinator: viewModel.favoritesCoordinator,
                                             networkService: viewModel.networkService,
                                             showingDetail: $showingDetail)
                            .onAppear {
                                viewModel.loadMoreContentIfNeeded(item: hike)
                            }
                            .padding()
                    }
                }
            }
            .hiddenNavigationBarStyle()
        }
    }
}

#if DEBUG
struct GridFavoriteFeedViewPreviews: PreviewProvider {
    static var previews: some View {
        FavoriteFeedView(viewModel:
                            FeedCoordinator(feedType: .favorites,
                                            favoritesCoordinator: FavoritesCoordinator()),
                         showingDetail: .constant(false))
    }
}
#endif
