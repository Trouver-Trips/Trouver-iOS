//
//  PhotoGridView.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/18/21.
//

import SwiftUI

struct PhotoGridView: View {
    let images: [URL]
    @State var showingFullPhoto = false
    @State var selectedPhoto = 0

    let gridLayout: [GridItem] = Array(repeating: .init(.flexible(minimum: 40)), count: 3)
    var body: some View {
          LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
            ForEach(Array(images.enumerated()), id: \.1) { index, imageUrl in
                Button(action: {
                    selectedPhoto = index
                    showingFullPhoto = true
                }, label: {
                    Color("CarouselBackground")
                        .aspectRatio(1, contentMode: .fill)
                        .overlay(
                           AsyncImage(url: imageUrl)
                                .scaledToFill()
                        )
                        .clipped()
                })
                .sheet(isPresented: $showingFullPhoto) {
                    FullPhotoView(images: images, selectedTab: $selectedPhoto)
                }
            }
          }
          .padding(10)
    }
}

#if DEBUG
struct PhotoGridViewPreviews: PreviewProvider {
    static var previews: some View {
        PhotoGridView(images: HikeData.hikeImages)
    }
}
#endif
