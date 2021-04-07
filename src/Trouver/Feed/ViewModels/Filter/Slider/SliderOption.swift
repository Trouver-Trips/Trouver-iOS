//
//  SliderOption.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import CoreGraphics
import Combine

enum Unit: String {
    case feet = "units.feet"
    case miles = "units.miles"
}

class SliderOption: ObservableObject {
    private let units: Unit
    
    private var lowRange: String {
        Int(slider.lowHandle.currentValue).description
    }
    
    private var highRange: String {
        Int(slider.highHandle.currentValue).description
    }
    
    let title: String
    let slider: DoubleSlider
    
    private var cancellable: AnyCancellable?
    
    init(title: String,
         units: Unit,
         start: Double,
         end: Double,
         width: CGFloat = 300) {
        self.title = title
        self.units = units
        slider = DoubleSlider(start: start, end: end, sliderWidth: width)
        
        cancellable = slider.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    var sliderRangeLabel: String {
        "\(lowRange) - \(highRange)"
    }
}
