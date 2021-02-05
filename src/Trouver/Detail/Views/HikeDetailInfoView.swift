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
                switch viewModel.state {
                case .idle: EmptyView()
                case .loading: ProgressView()
                case .loaded(let hikeDetail):
                    Text(hikeDetail.name)
                        .fontWeight(.bold)
                        .font(.system(.largeTitle, design: .rounded))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    ImageCarouselView(images: hikeDetail.imageUrls)
                        .frame(height: UIScreen.main.bounds.width * 3.0/4.0)
                        .background(Color(.systemGray5))
                    Group {
                        StarsView(rating: hikeDetail.rating, maxRating: 5)
                            .frame(width: 150)
                            .padding(.vertical)
                        GroupBox {
                            DisclosureGroup("more_photos_title") {
                                PhotoGridView(images: hikeDetail.imageUrls)
                            }
                            .accentColor(Color(UIColor.systemGray2))
                        }
                        WrappedHStack(items: hikeDetail.attributes)
                        Text(hikeDetail.description)
                    }
                    .padding(.horizontal)
                case .error:
                    HStack {
                        Text("Error Loading Details")
                    }
                }
            }
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
