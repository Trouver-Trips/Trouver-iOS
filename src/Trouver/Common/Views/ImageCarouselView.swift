//
//  ImageCarouselView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/24/20.
//

import SwiftUI

struct ImageCarouselView: View {
    let images: [URL]
    var body: some View {
        TabView {
            ForEach(images.prefix(5), id: \.self) { url in
                AsyncImage(url: url)
                    .aspectRatio(contentMode: .fit)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .background(Color("CarouselBackground"))
    }
}

#if DEBUG
struct ImageCarouselViewPreviews: PreviewProvider {
    static var previews: some View {
        ImageCarouselView(images: TrailData.trailImages)
    }
}
#endif
