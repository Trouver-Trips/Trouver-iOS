//
//  FeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/6/21.
//

import SwiftUI

struct FeedView: View {
    let isLoadingPage: Bool
    let networkService: NetworkService
    let hikes: [HikeInfo]
    let onAppear: (HikeInfo) -> Void
    
    var favoriteAction: ((HikeInfo) -> Void)?
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(hikes) { hikeInfo in
                    NavigationLink(destination:
                                    HikeDetailInfoView(viewModel:
                                                        HikeDetail(hikeInfo: hikeInfo,
                                                                            networkService: networkService))) {
                        FeedItemView(hikeInfo: hikeInfo, favoriteAction: favoriteAction)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 10)
                            .onAppear {
                                onAppear(hikeInfo)
                            }
                    }
                    .buttonStyle(FlatLinkStyle())
                }
            }

            if isLoadingPage {
              ProgressView()
            }
        }
        .fixFlickering { scrollView in
            scrollView
                .background(Color(.systemGray6))
        }
    }
}
