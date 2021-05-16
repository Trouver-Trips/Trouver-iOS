//
//  FeatureView.swift
//  Trouver
//
//  Created by Sagar Punhani on 5/16/21.
//

import SwiftUI

struct FeatureView: View {
    @AppStorage("showNewUI") var showNewUI = false
    @AppStorage("useLazyGrid") var useLazyGrid = false
    
    var body: some View {
        List {
            Toggle(isOn: $showNewUI) {
                Text("Show New UI")
            }
            Toggle(isOn: $useLazyGrid) {
                Text("Use Lazy Grid")
            }
        }
    }
}

#if DEBUG
struct FeatureViewPreviews: PreviewProvider {
    static var previews: some View {
        FeatureView()
    }
}
#endif
