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
    @State private var showLogOutMessage = false
    @State private var shouldHideNavBar = false
    
    let favoritesCoordinator: FavoritesCoordinator

    private var networkService: NetworkService {
        HikingNetworkService(accountHandle: loginViewModel.accountHandle)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if showNewUI {
                TabsContainer(images: ["homekit", "heart", "person.crop.circle"], shouldHideNavBar: $shouldHideNavBar) {
                    GridFeedView(showingDetail: $shouldHideNavBar,
                                 viewModel: FeedCoordinator(networkService: networkService,
                                                            feedType: .newsfeed,
                                                            favoritesCoordinator: favoritesCoordinator))
                    VStack {
                        Spacer()
                        Text("Favorites")
                        Spacer()
                    }
                    VStack {
                        Button (action: {
                            self.showLogOutMessage = true
                        }, label: {
                            Text("log.out.button.title")
                        })
                        .alert(isPresented: $showLogOutMessage) {
                            Alert(title: Text("log.out.message"),
                                  primaryButton: .default(Text("generic.okay.title"),
                                                          action: { loginViewModel.logOut() }),
                                  secondaryButton: .cancel())
                        }
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
                    .foregroundColor(Color.foregroundColor)
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
