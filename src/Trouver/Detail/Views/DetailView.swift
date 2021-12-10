//
//  DetailView.swift
//  Trouver
//
//  Created by Sagar Punhani on 5/18/21.
//

import SwiftUI

struct DetailView: View {
    private enum Constants {
        static let titleSize: CGFloat = 60
        static let shadowRadius: CGFloat = 8
        static let sidePadding: CGFloat = 32
        static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        static let sectionPadding: CGFloat = 12
        static let bottomPadding: CGFloat = 12
    }
    
    @EnvironmentObject var loginViewModel: LoginService
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: HikeDetailProvider
    var startingImageIndex: Int = 0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Group {
                switch viewModel.state {
                case .idle: EmptyView()
                case .loading: ProgressView()
                case .loaded(let hikeDetail):
                    VStack(spacing: Constants.sectionPadding) {
                        ZStack(alignment: .leading) {
                            ImagePageView(width: Constants.screenWidth,
                                          images: hikeDetail.imageUrls,
                                          startingImageIndex: startingImageIndex)
                            VStack(alignment: .leading) {
                                Spacer()
                                Text(hikeDetail.shortName)
                                    .fontWeight(.bold)
                                    .shadow(radius: Constants.shadowRadius)
                                    .font(.system(size: Constants.titleSize))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .rotationEffect(.degrees(-90), anchor: .topLeading)
                                    .padding(.bottom, Constants.bottomPadding)
                            }
                            .padding(.leading, Constants.sidePadding)
                        }
                        Group {
                            HStack {
                                IconLabel(image: "triangle", key: "units.feet.measurement \(hikeDetail.elevationGain)")
                                Spacer()
                                IconLabel(image: "map",
                                          key: "units.miles.measurement \(hikeDetail.length, specifier: "%.1f")")
                                Spacer()
                                switch hikeDetail.difficulty {
                                case .unknown:
                                    CapsuleView(text: "difficulty.option.unknown", color: .accentColor)
                                case .easy:
                                    CapsuleView(text: "difficulty.option.easy", color: .green)
                                case .moderate:
                                    CapsuleView(text: "difficulty.option.moderate", color: .yellow)
                                case .hard:
                                    CapsuleView(text: "difficulty.option.hard", color: .red)
                                }
                            }
                            VStack(alignment: .leading) {
                                Text("description.title")
                                    .font(.title)
                                    .padding(.vertical)
                                HStack {
                                    Text(hikeDetail.description)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                case .error:
                    HStack {
                        Text("generic.error")
                    }
                }
            }
//            .overlay(
//                DetailNavBar(isPresented: $isPresented, isFavorite: viewModel.isFavorite) {
//                    viewModel.toggleFavorite()
//                }
//            )
            .background(Color.themeColor)
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
                   viewModel: .init(hike: Hike.sampleData(),
                                    favoritesCoordinator: FavoritesCoordinator(),
                                    networkService: PreviewHikingService()))
            .preferredColorScheme(.dark)
    }
}
#endif
