//
//  FeedItemView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import SwiftUI

struct FeedItemView: View {
    
    @ObservedObject var viewModel: FeedCoordinator
    
    private var hikeIndex: Int {
        viewModel.hikes.firstIndex(of: hikeInfo) ?? -1
    }
    
    private let cornerRadius: CGFloat = 25
    let hikeInfo: HikeInfo

    var body: some View {
        ZStack {
            AsyncImage(url: hikeInfo.imageUrls[0], showPlaceHolder: true)
                .aspectRatio(contentMode: .fit)
            VStack {
                Spacer().frame(maxWidth: .infinity)
                HStack {
                    Text(hikeInfo.name)
                        .fontWeight(.bold)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                    if viewModel.showFavoriteToggle && hikeIndex >= 0 {
                        Button(action: {
                            viewModel.toggleFavorite(hike: hikeInfo)
                        }, label: {
                            Image(systemName: viewModel.hikes[hikeIndex].isFavorite ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.pink)
                                .padding()
                        })
                    }
                }
                .background(
                    Color.black
                        .opacity(0.7)
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // clip corners
        .shadow(color: Color("BackgroundColor").opacity(0.15), radius: 8, x: 0, y: 0)
        .padding(.horizontal)
    }
}

#if DEBUG
struct FeedItemViewPreviews: PreviewProvider {
    static var previews: some View {
        FeedItemView(viewModel: FeedCoordinator(feedType: .newsfeed,
                                                favoritesCoordinator: FavoritesCoordinator()),
                     hikeInfo: HikeInfo.sampleData())
    }
}
#endif
