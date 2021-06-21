//
//  GridFeedItemView.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/30/21.
//

import SwiftUI

struct GridFeedItemView: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 25
        static let minImageHeight: CGFloat = 150
    }
    
    let imageUrl: URL
    var body: some View {
        AsyncImage(url: imageUrl, showPlaceHolder: true)
            .frame(minHeight: Constants.minImageHeight)
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .shadow(color: Color.foregroundColor.opacity(0.15),
                    radius: 8, x: 0, y: 0)
    }
}

#if DEBUG
struct GridFeedItemViewPreviews: PreviewProvider {
    static var previews: some View {
        GridFeedItemView(imageUrl: HikeInfo.sampleData().imageUrls[0])
    }
}
#endif
