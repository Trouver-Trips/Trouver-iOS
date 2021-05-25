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
    
    private struct Constants {
        static let imageSize: CGFloat = 24
        static let topPadding: CGFloat = 32
        static let topMargin: CGFloat = 48
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
                    ImagePageView(width: screenWidth, images: hikeDetail.imageUrls)
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
                            Image(systemName: "suit.heart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Constants.imageSize,
                                       height: Constants.imageSize)
                                .foregroundColor(Color.foregroundColor)
                        }
                    }
                    .padding(.horizontal, Constants.topPadding)
                    .padding(.top, Constants.topMargin)
                    Spacer()
                }
            )
            .background(Color("ThemeColor"))
        }
        .onAppear {
            viewModel.onAppear()
            isPresented = true
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

#if DEBUG
struct DetailViewPreviews: PreviewProvider {
    static var previews: some View {
        DetailView(isPresented: .constant(true),
                   viewModel: HikeDetail(hikeInfo: HikeInfo.sampleData(), networkService: PreviewHikingService()))
            .preferredColorScheme(.dark)
    }
}
#endif
