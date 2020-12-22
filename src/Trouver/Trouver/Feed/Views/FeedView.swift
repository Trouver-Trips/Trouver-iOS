//
//  FeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/19/20.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var trailFeed: FeedViewModel

    var body: some View {
        List {
            ForEach(trailFeed.trails) { trail in
                Text(trail.name)
            }
        }
    }
}

struct FeedViewPreviews: PreviewProvider {
    static var previews: some View {
        FeedView(trailFeed: FeedViewModel())
    }
}
