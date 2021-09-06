//
//  MainView.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/27/21.
//

import SwiftUI

struct MainView: View {
    private enum Constants {
        static let iconSize: CGFloat = 30
    }
    
    @State private var showFeatureFlags = false
    @State private var showLogOutMessage = false
    @State private var shouldHideNavBar = false
    
    private var networkService: NetworkService {
        HikingNetworkService(accountHandle: loginViewModel.accountHandle)
    }
    
    let favoritesCoordinator: FavoritesCoordinator
    @EnvironmentObject var loginViewModel: LoginService
    
    var body: some View {
        VStack(alignment: .center) {
            TabsContainer(images: ["homekit", "heart", "person.crop.circle"], shouldHideNavBar: $shouldHideNavBar) {
                FeedView(viewModel:
                            .init(networkService: networkService,
                                  feedType: .newsfeed,
                                  favoritesCoordinator: favoritesCoordinator),
                                  showingDetail: $shouldHideNavBar)
                VStack {
                    FavoriteFeedView(viewModel:
                                        .init(networkService: networkService,
                                              feedType: .favorites,
                                              favoritesCoordinator: favoritesCoordinator),
                                     showingDetail: $shouldHideNavBar)
                }
                VStack {
                    #if DEBUG
                    HStack {
                        Button(action: {
                            showFeatureFlags = true
                        }, label: {
                            Image(systemName: "flag")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Constants.iconSize, height: Constants.iconSize)
                                .foregroundColor(Color.foregroundColor)
                                .padding()
                        })
                        Spacer()
                    }
                    .padding()
                    #endif
                    Spacer()
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
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showFeatureFlags) {
            FeatureView()
        }
    }
}

struct MainViewPreviews: PreviewProvider {
    static var previews: some View {
        MainView(favoritesCoordinator: .init())
            .environmentObject(LoginService())
    }
}
