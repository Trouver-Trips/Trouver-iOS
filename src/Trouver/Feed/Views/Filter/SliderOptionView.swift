//
//  SliderOptionView.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import SwiftUI

struct SliderOptionView: View {
    @ObservedObject var sliderOption: SliderOption
    
    var body: some View {
        VStack {
            HStack {
                Text(LocalizedStringKey(sliderOption.title))
                Spacer()
                Text(sliderOption.sliderRangeLabel)
            }
            SliderView(slider: sliderOption.slider)
        }
        .padding()
    }
}

struct SliderOptionViewPreviews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            SliderOptionView(sliderOption:
                                SliderOption(title: "length.title",
                                             units: .miles,
                                             start: 0,
                                             end: 100,
                                             width: geo.size.width - 30))
        }
    }
}
