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
            ForEach(images[0..<5], id: \.self) { url in
                AsyncImage(url: url, placeholder: { Image("Placeholder").resizable() })
                    .frame(maxWidth: 500, maxHeight: 300)
                    .scaledToFill()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .fixedSize()
    }
}

#if DEBUG
struct ImageCarouselViewPreviews: PreviewProvider {
    static var previews: some View {
        ImageCarouselView(images: TrailData.trailImages)
    }
}
#endif
