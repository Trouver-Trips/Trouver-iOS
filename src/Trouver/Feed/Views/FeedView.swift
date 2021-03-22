//
//  FeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/6/21.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel: FeedCoordinator
    
    var body: some View {
        //ScrollView {
            List {
                ForEach(viewModel.hikes) { hikeInfo in
                    NavigationLink(destination:
                                    HikeDetailInfoView(viewModel:
                                                        HikeDetail(hikeInfo: hikeInfo,
                                                                   networkService: viewModel.networkService))) {
                        FeedItemView(viewModel: viewModel, hikeInfo: hikeInfo)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 10)
                            .onAppear {
                                viewModel.loadMoreContentIfNeeded(item: hikeInfo)
                            }
                    }
                    .buttonStyle(FlatLinkStyle())
                }
            }

            if viewModel.isLoading {
              ProgressView()
            }
        
        //}
//        .fixFlickering { scrollView in
//            scrollView
//                .background(Color(.systemGray6))
//        }
    }
}
