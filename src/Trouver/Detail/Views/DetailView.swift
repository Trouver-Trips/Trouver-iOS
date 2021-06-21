//
//  DetailView.swift
//  Trouver
//
//  Created by Sagar Punhani on 5/18/21.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var loginViewModel: LoginService
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: HikeDetail
    
    var startingImageIndex: Int = 0
    
    private enum Constants {
        static let imageSize: CGFloat = 24
        static let sidePadding: CGFloat = 32
        static let topPadding: CGFloat = 48
        static let bottomPadding: CGFloat = 24
    }
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                switch viewModel.state {
                case .idle: EmptyView()
                case .loading:
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding(.top, Constants.topPadding)
                        Spacer()
                    }
                case .loaded(let hikeDetail):
                    ImagePageView(width: screenWidth,
                                  images: hikeDetail.imageUrls,
                                  startingImageIndex: startingImageIndex)
                    Text("description.title")
                        .padding()
                    Text(hikeDetail.description)
                case .error:
                    HStack {
                        Text("Error Loading Details")
                    }
                }
            }
            .overlay(
                VStack {
                    HStack {
                        Button(action: {
                            isPresented = false
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Constants.imageSize,
                                       height: Constants.imageSize)
                                .foregroundColor(Color.foregroundColor)
                        })
                        Spacer()
                        if case .loaded(_) = viewModel.state {
                            Button(action: {
                                viewModel.toggleFavorite()
                            }, label: {
                                Image(systemName: viewModel.isFavorite ? "suit.heart.fill" : "suit.heart")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: Constants.imageSize,
                                           height: Constants.imageSize)
                                    .foregroundColor(Color.foregroundColor)
                            })
                        }
                    }
                    .padding(.horizontal, Constants.sidePadding)
                    .padding(.top, Constants.topPadding)
                    .padding(.bottom, Constants.bottomPadding)
                    .background(
                        LinearGradient(gradient:
                                        Gradient(colors: [.black.opacity(0.8),
                                                          .black.opacity(0)]),
                                       startPoint: .top, endPoint: .bottom)
                    )
                    Spacer()
                }
            )
            .background(Color("ThemeColor"))
        }
        .onAppear {
            viewModel.onAppear()
            isPresented = true
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .hiddenNavigationBarStyle()
        .ignoresSafeArea()
    }
}

#if DEBUG
struct DetailViewPreviews: PreviewProvider {
    static var previews: some View {
        DetailView(isPresented: .constant(true),
                   viewModel: HikeDetail(hikeInfo: HikeInfo.sampleData(),
                                         favoritesCoordinator: FavoritesCoordinator(),
                                         networkService: PreviewHikingService()))
            .preferredColorScheme(.dark)
    }
}
#endif
