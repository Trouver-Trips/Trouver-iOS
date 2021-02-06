//
//  FeedView.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/19/20.
//

import SwiftUI

struct HikingFeedView: View {
    @ObservedObject var viewModel: HikingFeedViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    private var networkService: NetworkService {
        HikingNetworkingService(accountHandle: loginViewModel.accountHandle)
    }
        
    var body: some View {
        NavigationView {
            ScrollView {
                Group {
                    LazyVStack {
                        ForEach(viewModel.hikes) { hikeInfo in
                            NavigationLink(destination:
                                            HikeDetailInfoView(viewModel:
                                                                HikeDetailViewModel(hikeInfo: hikeInfo,
                                                                                    networkService: networkService))) {
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
                .background(Color(.systemGray6))
            }
            .navigationBarTitle("trouver_title")
            .navigationBarItems(trailing:
                Button (action: {
                    loginViewModel.logOut()
                }, label: {
                    Text("log_out_button_title")
                })
            )
            .searchView { location in
                viewModel.search(location: location)
            }
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
