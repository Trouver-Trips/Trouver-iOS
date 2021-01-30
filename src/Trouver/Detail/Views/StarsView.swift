//
//  StarsView.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/28/21.
//

import SwiftUI

struct StarsView: View {
    let rating: CGFloat
    let maxRating: Int

    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<maxRating) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }

        stars.overlay(
            GeometryReader { g in
                let width = rating / CGFloat(maxRating) * g.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.yellow)
                }
            }
            .mask(stars)
        )
        .foregroundColor(.gray)
    }
}

struct StarsViewPreviews: PreviewProvider {
    static var previews: some View {
        StarsView(rating: 3.5, maxRating: 5)
    }
}
