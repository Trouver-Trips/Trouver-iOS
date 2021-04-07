//
//  SliderPathBetweenView.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import SwiftUI

struct SliderPathBetweenView: View {
    @ObservedObject var slider: DoubleSlider
    
    var body: some View {
        Path { path in
            path.move(to: slider.lowHandle.currentLocation)
            path.addLine(to: slider.highHandle.currentLocation)
        }
        .stroke(Color.accentColor, lineWidth: slider.lineWidth)
    }
}
