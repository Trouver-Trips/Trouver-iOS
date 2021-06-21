//
//  FavoriteImageView.swift
//  Trouver
//
//  Created by Sagar Punhani on 6/20/21.
//

import SwiftUI

struct FavoriteImageView: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let shadowRadius: CGFloat = 8
    }
    
    let url: URL
    var corners: UIRectCorner = .allCorners
    
    var body: some View {
        AsyncImage(url: url)
            .aspectRatio(1.0, contentMode: .fit)
            .shadow(color: Color.foregroundColor.opacity(0.15),
                    radius: Constants.shadowRadius, x: 0, y: 0)
            .cornerRadius(Constants.cornerRadius, corners: corners)
    }
}

#if DEBUG
struct GridFavoriteImageViewPreviews: PreviewProvider {
    static var previews: some View {
        FavoriteImageView(url: HikeData.hikeImages[0])
    }
}
#endif
