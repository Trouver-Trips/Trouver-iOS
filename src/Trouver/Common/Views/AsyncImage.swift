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
    private let showPlaceHolder: Bool

    init(url: URL, showPlaceHolder: Bool = false) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
        self.showPlaceHolder = showPlaceHolder
    }

    var body: some View {
        VStack {
            ZStack {
                if let uiImage = loader.image {
                    Image(uiImage: uiImage)
                        .resizable()
                } else {
                    if showPlaceHolder {
                        Image("Logo")
                            .resizable()
                    } else {
                        EmptyView()
                    }
                }
            }
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
