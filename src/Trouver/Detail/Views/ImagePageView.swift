//
//  ImagePageView.swift
//  Trouver
//
//  Created by Sagar Punhani on 5/20/21.
//

import SwiftUI

struct ImagePageView: View {
    private enum Constants {
        static let tabBarBottomMargin: CGFloat = 16
        static let imageRatio: CGFloat = 0.75
    }
    
    private var imageCount: Int { min(images.count, 5) }
    @State private var index: Int = 0

    let width: CGFloat
    let images: [URL]
    let startingImageIndex: Int

    var body: some View {
        ZStack {
            TabPagesView(width: width, index: $index, maxIndex: imageCount - 1, useWeakGesture: true) {
                ForEach(images.prefix(imageCount), id: \.self) { url in
                    Color.themeColor
                        .aspectRatio(Constants.imageRatio, contentMode: .fill)
                        .overlay(
                            AsyncImage(url: url)
                                .scaledToFill()
                        ).clipped()
                }
            }
            .onAppear {
                index = startingImageIndex
            }
            VStack {
                Spacer()
                HStack {
                    ForEach(0..<imageCount) { index in
                        Button(action: {
                            self.index = index
                        }, label: {
                            TabBarItem(systemIconName: "circle.fill",
                                       isHighlighted: self.index == index,
                                       size: 12,
                                       padding: 3)
                        })
                    }
                }
                .padding(.bottom, Constants.tabBarBottomMargin)
            }
        }
    }
}

#if DEBUG
struct ImagePageViewPreviews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ImagePageView(width: geo.size.width, images: HikeData.hikeImages ?? [], startingImageIndex: 0)
        }
    }
}
#endif
