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
    
    @State private var showSortView: Bool = false
        
    private var networkService: NetworkService {
        HikingNetworkService(accountHandle: loginViewModel.accountHandle)
    }
        
    var body: some View {
        NavigationView {
            FeedView(viewModel: viewModel)
            .navigationBarTitle("trouver.title")
            .navigationBarItems(
                leading:
                    Button (action: {
                        showSortView = true
                    }, label: {
                        Text("filter.title")
                    }),
                trailing:
                    Button (action: {
                        loginViewModel.logOut()
                    }, label: {
                        Text("log.out.button.title")
                    })
            )
            .searchView { location in
                viewModel.search(location: location)
            }
        }
        .sheet(isPresented: $showSortView) {
            GeometryReader { geo in
                FilterView(filter: FilterCoordinator(width: geo.size.width - 50))
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
