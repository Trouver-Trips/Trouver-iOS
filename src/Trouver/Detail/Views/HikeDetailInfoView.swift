//
//  HikeDetailInfoView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/22/20.
//

import SwiftUI

struct HikeDetailInfoView: View {
    @ObservedObject var viewModel: HikeDetailViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Text(viewModel.name)
                    .fontWeight(.bold)
                    .font(.system(.largeTitle, design: .rounded))
                ImageCarouselView(images: viewModel.hikeImages)
                    .frame(height: UIScreen.main.bounds.width * 3.0/4.0)
                WrappedHStack(items: viewModel.attributes)
                GroupBox {
                    DisclosureGroup("more_photos_title") {
                        PhotoGridView(images: viewModel.hikeImages)
                            .padding()
                    }
                    .accentColor(Color(UIColor.systemGray2))
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

#if DEBUG
struct HikeDetailInfoViewPreviews: PreviewProvider {
    static var previews: some View {
        HikeDetailInfoView(viewModel:
                            HikeDetailViewModel(hikeInfo: HikeInfo.sampleData()))
    }
}
#endif
