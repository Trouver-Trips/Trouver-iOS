//
//  FullPhotoView.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/18/21.
//

import SwiftUI

struct FullPhotoView: View {
    let images: [URL]
    @Binding var selectedTab: Int

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Array(images.enumerated()), id: \.1) { index, url in
                AsyncImage(url: url)
                    .aspectRatio(contentMode: .fit)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct FullPhotoViewPreviews: PreviewProvider {
    @State static private var tab = 2
    static var previews: some View {
        FullPhotoView(images: HikeData.hikeImages, selectedTab: $tab)
    }
}
#endif
