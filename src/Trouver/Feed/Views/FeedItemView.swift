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
    let hikeInfo: HikeInfo
    let favoriteAction: ((HikeInfo) -> Void)?

    var body: some View {
        VStack {
            AsyncImage(url: hikeInfo.imageUrls[0], showPlaceHolder: true)
                .aspectRatio(contentMode: .fit)
            Text(hikeInfo.name)
                .fontWeight(.bold)
                .font(.title)
                .padding()
            if let action = favoriteAction {
                Button(action: {
                    action(hikeInfo)
                }, label: {
                    Image(systemName: hikeInfo.isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.pink)
                        .padding()
                })
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // clip corners
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color("BackgroundColor"))
                .shadow(color: Color("BackgroundColor"), radius: 3)
        )
        .padding(.horizontal)
    }
}

#if DEBUG
struct FeedItemViewPreviews: PreviewProvider {
    static var previews: some View {
        FeedItemView(hikeInfo: HikeInfo.sampleData(), favoriteAction: nil)
    }
}
#endif
