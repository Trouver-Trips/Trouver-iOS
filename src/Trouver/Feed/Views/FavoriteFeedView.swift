//
//  FavoriteFeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/6/21.
//

import SwiftUI

struct FavoriteFeedView: View {
    @ObservedObject var viewModel: FavoriteFeedCoordinator
    @EnvironmentObject var loginService: LoginService
    
    private var networkService: NetworkService {
        HikingNetworkService(accountHandle: loginService.accountHandle)
    }
        
    var body: some View {
        NavigationView {
            FeedView(isLoadingPage: viewModel.isLoading,
                     networkService: networkService,
                     hikes: viewModel.hikes,
                     onAppear: {
                        viewModel.loadMoreContentIfNeeded(currentItem: $0)
                     })
            .navigationBarTitle("favorites_title")
            .navigationBarItems(trailing:
                Button (action: {
                    loginService.logOut()
                }, label: {
                    Text("log_out_button_title")
                })
            )
        }
    }
}

#if DEBUG
struct FavoriteFeedViewPreviews: PreviewProvider {
    static var previews: some View {
        FavoriteFeedView(viewModel: FavoriteFeedCoordinator())
            .environmentObject(LoginService())
    }
}
#endif
