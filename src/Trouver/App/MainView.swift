//
//  MainView.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/27/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    private var networkService: NetworkService {
        HikingNetworkingService(accountHandle: loginViewModel.accountHandle)
    }

    var body: some View {
        TabView {
            HikingFeedView(viewModel:
                            HikingFeedViewModel(networkService: networkService))
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Feed")
                }
            EmptyView()
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
    }
}
