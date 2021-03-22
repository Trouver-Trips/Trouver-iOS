//
//  MainView.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/27/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var favoritesCoordinator: FavoritesCoordinator
    @EnvironmentObject var loginViewModel: LoginService
    
    private var networkService: NetworkService {
        HikingNetworkService(accountHandle: loginViewModel.accountHandle)
    }
    
    var body: some View {
        TabView {
            HikingFeedView(viewModel: FeedCoordinator(networkService: networkService,
                                                      feedType: .newsfeed,
                                                      favoritesCoordinator: favoritesCoordinator))
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Feed")
                }
            FavoriteFeedView(viewModel: FeedCoordinator(networkService: networkService,
                                                        feedType: .favorites,
                                                        favoritesCoordinator: favoritesCoordinator))
                .tabItem {
                    Image(systemName: "suit.heart.fill")
                    Text("Favorites")
                }
        }
    }
}

struct MainViewPreviews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LoginService())
    }
}
