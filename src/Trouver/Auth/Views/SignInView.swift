//
//  SignInView.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userViewModel: TrouverUserViewModel
    @StateObject var trailFeed: HikingFeedViewModel = HikingFeedViewModel()

    // To use if/else in our body, we need to wrap the view in a Group
    var body: some View {
        ZStack {
            switch userViewModel.signInState {
            case .signedIn: HikingFeedView(viewModel: trailFeed)
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
            }
        }
    }
}

struct SignInViewPreviews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(TrouverUserViewModel())
    }
}
