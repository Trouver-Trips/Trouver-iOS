//
//  FeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/19/20.
//

import SwiftUI

struct HikingFeedView: View {
    @ObservedObject var viewModel: HikingFeedViewModel
    @EnvironmentObject var userViewModel: TrouverUserViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.hikes) { hikeInfo in
                        NavigationLink(destination:
                                        HikeDetailInfoView(viewModel: HikeDetailViewModel(hikeInfo: hikeInfo))) {
                            HikingFeedItemView(hikeInfo: hikeInfo)
                                .listRowInsets(EdgeInsets())
                                .padding(.vertical, 10)
                                .onAppear {
                                    self.viewModel.loadMoreContentIfNeeded(currentItem: hikeInfo)
                                }
                        }
                        .buttonStyle(FlatLinkStyle())
                    }
                }

                if viewModel.isLoadingPage {
                  ProgressView()
                }
            }
            .navigationBarTitle("trouver_title")
            .navigationBarItems(trailing:
                Button (action: {
                    userViewModel.logOut()
                }, label: {
                    Text("log_out_button_title")
                })
            )
        }
    }
}

#if DEBUG
struct FeedViewPreviews: PreviewProvider {
    static var previews: some View {
        HikingFeedView(viewModel: HikingFeedViewModel())
    }
}
#endif
