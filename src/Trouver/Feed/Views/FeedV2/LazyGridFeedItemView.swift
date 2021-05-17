//
//  LazyGridFeedItemView.swift
//  Trouver
//
//  Created by Sagar Punhani on 5/16/21.
//

import SwiftUI

struct LazyGridFeedItemView: View {
    struct Constants {
        static let cornerRadius: CGFloat = 25
        static let opacity: Double = 0.15
        static let radius: CGFloat = 8
        static let imageRatio: CGFloat = 9/16
    }
    
    let imageUrl: URL
    var body: some View {
        Color.accentColor
            .aspectRatio(Constants.imageRatio, contentMode: .fill)
            .overlay(
                AsyncImage(url: imageUrl)
                    .scaledToFill()
            ).clipped()
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .shadow(color: Color("BackgroundColor").opacity(Constants.opacity),
                    radius: Constants.radius, x: 0, y: 0)
    }
}

#if DEBUG
struct LazyGridFeedItemViewPreviews: PreviewProvider {
    static var previews: some View {
        LazyGridFeedItemView(imageUrl: HikeInfo.sampleData().imageUrls[0])
    }
}
#endif
