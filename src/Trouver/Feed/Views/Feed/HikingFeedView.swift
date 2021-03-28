//
//  HikingFeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/19/20.
//

import SwiftUI

struct HikingFeedView: View {
    @ObservedObject var viewModel: FeedCoordinator
    @EnvironmentObject var loginViewModel: LoginService
        
    private var networkService: NetworkService {
        HikingNetworkService(accountHandle: loginViewModel.accountHandle)
    }
        
    var body: some View {
        NavigationView {
            FeedView(viewModel: viewModel)
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
        HikingFeedView(viewModel: FeedCoordinator(feedType: .newsfeed, favoritesCoordinator: FavoritesCoordinator()))
            .environmentObject(LoginService())
    }
}
#endif
