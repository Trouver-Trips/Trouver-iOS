//
//  AsyncImage.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/24/20.
//

import SwiftUI

/*
 View to download an image url in async
 https://github.com/V8tr/AsyncImage
 */
struct AsyncImage: View {
    @StateObject private var loader: ImageLoader

    init(url: URL) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }

    var body: some View {
        VStack {
            ZStack {
                if let uiImage = loader.image {
                    Image(uiImage: uiImage)
                        .resizable()
                } else {
                    EmptyView()
                }
            }
            .opacity(loader.image != nil ? 1 : 0)
            .animation(.default)
            .aspectRatio(contentMode: .fit)
        }
    }
}

#if DEBUG
struct AsyncImageViewPreviews: PreviewProvider {
    static var previews: some View {
        AsyncImage(url: HikeData.hikeImages[0])
    }
}
#endif
