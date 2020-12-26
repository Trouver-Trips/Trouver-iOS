//
//  TrouverApp.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/19/20.
//

import SwiftUI

@main
struct TrouverApp: App {
    @StateObject var trailFeed: HikingFeedViewModel = HikingFeedViewModel()

    var body: some Scene {
        WindowGroup {
            HikingFeedView(viewModel: trailFeed)
        }
    }
}
