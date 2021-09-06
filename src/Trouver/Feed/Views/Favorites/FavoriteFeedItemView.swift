//
//  FavoriteFeedItemView.swift
//  Trouver
//
//  Created by Sagar Punhani on 6/20/21.
//

import SwiftUI

struct FavoriteFeedItemView: View {
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let removableCorners: [UIRectCorner] = [
        .bottomRight,
        .bottomLeft,
        .topRight,
        .topLeft
    ]
    
    let hike: Hike
    let favoritesCoordinator: FavoritesCoordinator
    let networkService: NetworkService
    @Binding var showingDetail: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(hike.name)
                .font(.title2)
                .lineLimit(nil)
            HStack {
                NavigationLink(destination:
                                DetailView(isPresented: $showingDetail,
                                           viewModel: viewModel(for: hike))) {
                    FavoriteImageView(url: hike.imageUrls[0])
                }
                .buttonStyle(FlatLinkStyle())
                LazyVGrid(columns: columns) {
                    ForEach(1..<hike.imageUrls.count) { idx in
                        NavigationLink(destination:
                                        DetailView(isPresented: $showingDetail,
                                                   viewModel: viewModel(for: hike),
                                                   startingImageIndex: idx)) {
                            FavoriteImageView(url: hike.imageUrls[idx],
                                              corners:
                                                UIRectCorner.allCorners.subtracting(removableCorners[idx - 1]))
                                .overlay(
                                    idx == hike.imageUrls.count - 1 ?
                                    ZStack {
                                        Color.black.opacity(0.5)
                                        Text("+45")
                                    } : nil
                                )
                        }
                        .buttonStyle(FlatLinkStyle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private func viewModel(for hike: Hike) -> HikeDetailProvider {
        .init(hike: hike,
              favoritesCoordinator: favoritesCoordinator,
              networkService: networkService)
    }
}

#if DEBUG
struct GridFavoriteFeedItemViewPreviews: PreviewProvider {
    static var previews: some View {
        FavoriteFeedItemView(hike: Hike.sampleData(),
                             favoritesCoordinator: FavoritesCoordinator(),
                             networkService: HikingNetworkService(),
                             showingDetail: .constant(false))
    }
}
#endif
