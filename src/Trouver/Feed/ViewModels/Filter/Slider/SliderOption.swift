//
//  SliderOption.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import CoreGraphics
import Combine
import Foundation

enum Unit: String {
    case feet = "units.feet"
    case miles = "units.miles"
}

class SliderOption: ObservableObject {
    private let units: Unit
    
    private var lowRange: Double {
        slider.lowHandle.currentValue
    }
    
    private var highRange: Double {
        slider.highHandle.currentValue
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
        let low: String
        let high: String
        let unitDescription = Bundle.main.localizedString(forKey: units.rawValue, value: nil, table: nil)
        switch units {
        case .feet:
            low = Int(lowRange.toFeet).description
            high = Int(highRange.toFeet).description
        case .miles:
            low = Int(lowRange.toMiles).description
            high = Int(highRange.toMiles).description
        }
        
        return "\(low) \(unitDescription) - \(high) \(unitDescription)"
    }
}
