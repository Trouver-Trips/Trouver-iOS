//
//  SliderView.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import SwiftUI

struct SliderView: View {
    @ObservedObject var slider: DoubleSlider
    
    var body: some View {
        RoundedRectangle(cornerRadius: slider.lineWidth)
            .fill(Color.gray.opacity(0.2))
            .frame(width: slider.width, height: slider.lineWidth)
            .overlay(
                ZStack {
                    //Path between both handles
                    SliderPathBetweenView(slider: slider)
                    
                    //Low Handle
                    SliderHandleView(handle: slider.lowHandle)
                        .highPriorityGesture(slider.lowHandle.sliderDragGesture)
                    
                    //High Handle
                    SliderHandleView(handle: slider.highHandle)
                        .highPriorityGesture(slider.highHandle.sliderDragGesture)
                }
            )
    }
}

struct SliderViewPreviews: PreviewProvider {
    static var previews: some View {
        SliderView(slider: DoubleSlider(start: 0, end: 100))
    }
}
