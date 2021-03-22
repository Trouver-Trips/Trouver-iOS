//
//  SignInView.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userViewModel: LoginService
    
    private var networkService: NetworkService {
        HikingNetworkService(accountHandle: userViewModel.accountHandle)
    }

    // To use if/else in our body, we need to wrap the view in a Group
    var body: some View {
        ZStack {
            switch userViewModel.signInState {
            case .signedIn:
                MainView(favoritesCoordinator: FavoritesCoordinator(networkService: networkService))
            case .notSignedIn:
                ZStack {
                    Image("Rainier")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.vertical)
                    GeometryReader { geometry in
                        VStack {
                            Text("trouver_title")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(.largeTitle, design: .rounded))
                            GoogleSignInButton()
                        }
                        .frame(width: 300)
                        .position(x: geometry.size.width / 2, y: geometry.size.height)
                    }
                }
            case .tryingSilentSignIn: ProgressView()
            case .error: Text("generic_error")
            }
        }
    }
}

struct SignInViewPreviews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(LoginService())
    }
}
