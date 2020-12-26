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
struct AsyncImage<Placeholder: View>: View {
    @ObservedObject var loader: ImageLoader
    @State private var isLoaded = false

    private let placeholder: Placeholder

    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        loader = ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue)
    }

    var body: some View {
        VStack {
            Group {
                if let uiImage = loader.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .onAppear {
                            isLoaded = true
                        }
                } else {
                    placeholder
                }
            }
            .opacity(isLoaded ? 1 : 0)
            .animation(.default)
        }
    }
}

#if DEBUG
struct AsyncImageViewPreviews: PreviewProvider {
    static var previews: some View {
        AsyncImage(url: TrailData.trailImages[0],
                   placeholder: { Image("Placeholder").resizable()
                   })
            .frame(maxWidth: 500, maxHeight: 300)
    }
}
#endif
