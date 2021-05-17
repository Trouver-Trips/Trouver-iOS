//
//  MainView.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/27/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var loginViewModel: LoginService
    @AppStorage("showNewUI") var showNewUI = true
    @State private var showFeatureFlags = false
    
    let favoritesCoordinator: FavoritesCoordinator

    private var networkService: NetworkService {
        HikingNetworkService(accountHandle: loginViewModel.accountHandle)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if showNewUI {
                TabsContainer(images: ["homekit", "heart", "person.crop.circle"]) {
                    GridFeedView(viewModel: FeedCoordinator(networkService: networkService,
                                                              feedType: .newsfeed,
                                                              favoritesCoordinator: favoritesCoordinator))
                    VStack {
                        Spacer()
                        Text("Favorites")
                        Spacer()
                    }
                    VStack {
                        Button (action: {
                            loginViewModel.logOut()
                        }, label: {
                            Text("log.out.button.title")
                        })
                    }
                    .padding()
                }
            } else {
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
            #if DEBUG
            Button(action: {
                showFeatureFlags = true
            }, label: {
                Image(systemName: "flag")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("TabBarHighlight"))
                    .padding()
            })
            #endif
        }
        .sheet(isPresented: $showFeatureFlags) {
            FeatureView()
        }
    }
}

struct MainViewPreviews: PreviewProvider {
    static var previews: some View {
        MainView(favoritesCoordinator: FavoritesCoordinator())
            .environmentObject(LoginService())
    }
}
