//
//  HikingFeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/19/20.
//

import SwiftUI

enum FavoriteState {
    case showOverlay(String)
    case hideOverlay
}

struct HikingFeedView: View {
    @ObservedObject var viewModel: HikingFeedCoordinator
    @EnvironmentObject var loginViewModel: LoginService
    @EnvironmentObject var favorites: FavoriteFeedCoordinator
    
    @State private var favoriteState: FavoriteState = .hideOverlay
    
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
                     },
                     onItemDoubleTap: {
                        self.showImage(name: self.favorites.update($0) ? "heart.fill" : "heart.slash.fill")
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
            .overlay(
                Group {
                    switch self.favoriteState {
                    case .showOverlay(let name):
                        Image(systemName: name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.pink)
                            .padding(60)
                    default: EmptyView()
                    }
                }
                .animation(.easeIn)
            )
        }
    }
    
    private func showImage(name: String) {
        self.favoriteState = .showOverlay(name)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.favoriteState = .hideOverlay
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
