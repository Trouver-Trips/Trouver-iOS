//
//  SliderHandle.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import SwiftUI
import Combine

class SliderHandle: ObservableObject {
    
    // Slider Size
    let sliderWidth: CGFloat
    let sliderHeight: CGFloat
    
    // Slider Range
    let sliderValueStart: Double
    let sliderValueRange: Double
    
    // Slider Handle
    var diameter: CGFloat = 20
    var startLocation: CGPoint
    
    // Current Value
    @Published var currentValue: Double
    @Published var currentPercentage: SliderValue {
        didSet {
            currentValue = sliderValueStart + currentPercentage.wrappedValue * sliderValueRange
        }
    }

    // Slider Button Location
    @Published var onDrag: Bool
    @Published var currentLocation: CGPoint
        
    init(sliderWidth: CGFloat,
         sliderHeight: CGFloat,
         sliderValueStart: Double,
         sliderValueEnd: Double,
         startPercentage: SliderValue) {
        self.sliderWidth = sliderWidth
        self.sliderHeight = sliderHeight
        
        self.sliderValueStart = sliderValueStart
        self.sliderValueRange = sliderValueEnd - sliderValueStart
        
        let startLocation = CGPoint(x: (CGFloat(startPercentage.wrappedValue)/1.0)*sliderWidth, y: sliderHeight/2)
        
        self.startLocation = startLocation
        self.currentLocation = startLocation
        self.currentValue = sliderValueStart + startPercentage.wrappedValue * sliderValueRange
        self.currentPercentage = startPercentage
        
        self.onDrag = false
    }
    
    lazy var sliderDragGesture: _EndedGesture<_ChangedGesture<DragGesture>> = DragGesture()
        .onChanged { value in
            self.onDrag = true
            
            let dragLocation = value.location
            
            // Restrict possible drag area
            self.restrictSliderBtnLocation(dragLocation)
            
            // Get current value
            self.currentPercentage.wrappedValue = Double(self.currentLocation.x / self.sliderWidth)
            
        }.onEnded { _ in
            self.onDrag = false
        }
    
    private func restrictSliderBtnLocation(_ dragLocation: CGPoint) {
        // On Slider Width

        let xOffset = min(max(0, dragLocation.x), sliderWidth)
        calcSliderBtnLocation(CGPoint(x: xOffset, y: dragLocation.y))
    }
    
    private func calcSliderBtnLocation(_ dragLocation: CGPoint) {
        if dragLocation.y != sliderHeight/2 {
            currentLocation = CGPoint(x: dragLocation.x, y: sliderHeight/2)
        } else {
            currentLocation = dragLocation
        }
    }
}
