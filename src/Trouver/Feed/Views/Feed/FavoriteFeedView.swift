//
//  FavoriteFeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/6/21.
//

import SwiftUI

struct FavoriteFeedView: View {
    @ObservedObject var viewModel: FeedCoordinator
    @EnvironmentObject var loginService: LoginService
    
    private var networkService: NetworkService {
        HikingNetworkService(accountHandle: loginService.accountHandle)
    }
        
    var body: some View {
        NavigationView {
            FeedView(viewModel: viewModel)
            .navigationBarTitle("favorites.title")
            .navigationBarItems(trailing:
                Button (action: {
                    loginService.logOut()
                }, label: {
                    Text("log.out.button.title")
                })
            )
        }
    }
}

#if DEBUG
struct FavoriteFeedViewPreviews: PreviewProvider {
    static var previews: some View {
        FavoriteFeedView(viewModel: FeedCoordinator(feedType: .favorites, favoritesCoordinator: FavoritesCoordinator()))
            .environmentObject(LoginService())
    }
}
#endif
