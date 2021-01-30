//
//  MainView.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/27/21.
//

import SwiftUI

struct MainView: View {
    @StateObject var hikeFeed: HikingFeedViewModel = HikingFeedViewModel()

    var body: some View {
        TabView {
            HikingFeedView(viewModel: hikeFeed)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Feed")
                }
            HikingFeedView(viewModel: hikeFeed)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Favorites")
                }
        }
    }
}

struct MainViewPreviews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
