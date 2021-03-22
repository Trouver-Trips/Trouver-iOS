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
                        .padding([.trailing], -34.0)
                }
                .buttonStyle(FlatLinkStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .listRowInsets(EdgeInsets())
                .background(Color(.systemBackground))
            }
        }

        if viewModel.isLoading {
          ProgressView()
        }
    }
}
