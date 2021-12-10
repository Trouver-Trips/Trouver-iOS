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
    @State private var showSignOutMessage = false
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
                    Button(action: {
                        self.showSignOutMessage = true
                    }, label: {
                        Text("sign.out.button.title")
                    })
                    .alert(isPresented: $showSignOutMessage) {
                        Alert(title: Text("sign.out.message"),
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

#if DEBUG
struct MainViewPreviews: PreviewProvider {
    static var previews: some View {
        MainView(favoritesCoordinator: .init())
            .environmentObject(LoginService())
    }
}
#endif
