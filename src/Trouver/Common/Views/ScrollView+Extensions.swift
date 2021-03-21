//
//  ScrollView+Extensions.swift
//  Trouver
//
//  Created by Sagar Punhani on 2/20/21.
//

import SwiftUI

extension ScrollView {
    
    public func fixFlickering() -> some View {
        return fixFlickering { (scrollView) in
            return scrollView
        }
    }
    
    public func fixFlickering<T: View>(@ViewBuilder configurator: @escaping (ScrollView<AnyView>) -> T) -> some View {
        GeometryReader { geometryWithSafeArea in
            GeometryReader { _ in
                configurator(
                ScrollView<AnyView>(axes, showsIndicators: showsIndicators) {
                    AnyView(
                    VStack {
                        content
                    }
                    .padding(.top, geometryWithSafeArea.safeAreaInsets.top)
                    .padding(.bottom, geometryWithSafeArea.safeAreaInsets.bottom)
                    .padding(.leading, geometryWithSafeArea.safeAreaInsets.leading)
                    .padding(.trailing, geometryWithSafeArea.safeAreaInsets.trailing)
                    )
                }
                )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
