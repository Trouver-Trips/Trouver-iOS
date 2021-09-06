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
        static let iconSize: CGFloat = 24
    }
    
    private var imageCount: Int { min(images.count, 5) }
    @State private var showFullPhoto: Bool = false
    @State private var index: Int = 0
    
    private var maxIndex: Int { imageCount - 1 }

    let width: CGFloat
    let images: [URL]
    let startingImageIndex: Int

    var body: some View {
        ZStack {
            TabPagesView(width: width, index: $index, maxIndex: maxIndex, useWeakGesture: true) {
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
                ZStack {
                    HStack {
                        ForEach(0..<imageCount) { index in
                            Button(action: {
                                self.index = index
                            }, label: {
                                TabBarItem(systemIconName: "circle.fill",
                                           isHighlighted: index == min(self.index, maxIndex),
                                           size: 12,
                                           padding: 3)
                            })
                        }
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showFullPhoto = true
                        }, label: {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Constants.iconSize,
                                       height: Constants.iconSize)
                                .foregroundColor(.foregroundColor)
                        })
                        .padding()
                    }
                }
                .padding(.bottom, Constants.tabBarBottomMargin)
                .background(
                    LinearGradient(gradient:
                                    Gradient(colors: [Color.black.opacity(0.8),
                                                      Color.black.opacity(0)]),
                                   startPoint: .bottom, endPoint: .top)
                )
            }
        }
        .sheet(isPresented: $showFullPhoto) {
            FullPhotoView(images: images, selectedTab: $index)
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
