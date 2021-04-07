//
//  FilterView.swift
//  Trouver
//
//  Created by Sagar Punhani on 3/27/21.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var filter: FilterCoordinator
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        SelectorView(viewModel: filter.sortSelector)
                        Divider()
                        SelectorView(viewModel: filter.difficultySelector)
                        Divider()
                        SliderOptionView(sliderOption: filter.lengthSlider)
                        Divider()
                        SliderOptionView(sliderOption: filter.elevationSlider)
                    }
                }
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("See All Trails")
                })
            }
            .navigationBarTitle("filter.title", displayMode: .inline)
        }
    }
}

struct FilterViewPreviews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            FilterView(filter: FilterCoordinator(width: geo.size.width - 50))
        }
    }
}
