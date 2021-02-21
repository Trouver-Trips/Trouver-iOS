//
//  FeedItemView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import SwiftUI

struct FeedItemView: View {
    // Private members
    private let cornerRadius: CGFloat = 25

    var hikeInfo: HikeInfo

    var body: some View {
        VStack {
            Text(hikeInfo.name)
                .fontWeight(.bold)
                .font(.title)
            AsyncImage(url: hikeInfo.imageUrls[0], showPlaceHolder: true)
                .cornerRadius(cornerRadius)
                .shadow(color: Color("BackgroundColor"), radius: 3)
                .aspectRatio(contentMode: .fit)
        }
        .padding(.horizontal)
    }
}

#if DEBUG
struct FeedItemViewPreviews: PreviewProvider {
    static var previews: some View {
        FeedItemView(hikeInfo: HikeInfo.sampleData())
    }
}
#endif
