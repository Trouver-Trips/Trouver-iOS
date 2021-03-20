//
//  HikingFeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/19/20.
//

import SwiftUI

struct HikingFeedView: View {
    @ObservedObject var viewModel: HikingFeedCoordinator
    @EnvironmentObject var loginViewModel: LoginService
    @EnvironmentObject var favorites: FavoriteFeedCoordinator
        
    private var networkService: NetworkService {
        HikingNetworkService(accountHandle: loginViewModel.accountHandle)
    }
        
    var body: some View {
        NavigationView {
            FeedView(isLoadingPage: viewModel.isLoadingPage,
                     networkService: networkService,
                     hikes: viewModel.hikes,
                     onAppear: {
                        self.viewModel.loadMoreContentIfNeeded(currentItem: $0)
                     }, favoriteAction: {
                        self.favorites.update($0)
                        self.viewModel.toggleFavorite(hike: $0)
                     })
            .navigationBarTitle("trouver_title")
            .navigationBarItems(trailing:
                Button (action: {
                    loginViewModel.logOut()
                }, label: {
                    Text("log_out_button_title")
                })
            )
            .searchView { location in
                viewModel.search(location: location)
            }
        }
    }
}

#if DEBUG
struct HikingFeedViewPreviews: PreviewProvider {
    static var previews: some View {
        HikingFeedView(viewModel: HikingFeedCoordinator())
            .environmentObject(FavoriteFeedCoordinator())
    }
}
#endif
