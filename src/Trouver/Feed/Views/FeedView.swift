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
    var onItemDoubleTap: ((HikeInfo) -> Void)?
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(hikes) { hikeInfo in
                    NavigationLink(destination:
                                    HikeDetailInfoView(viewModel:
                                                        HikeDetail(hikeInfo: hikeInfo,
                                                                            networkService: networkService))) {
                        FeedItemView(hikeInfo: hikeInfo)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 10)
                            .onAppear {
                                self.onAppear(hikeInfo)
                            }
                            .gesture(getTapGesture(hike: hikeInfo))
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
    
    func getTapGesture(hike: HikeInfo) -> some Gesture {
        let gesture = TapGesture(count: 2).onEnded { onItemDoubleTap?(hike) }
        return onItemDoubleTap != nil ? gesture : nil
    }
}
