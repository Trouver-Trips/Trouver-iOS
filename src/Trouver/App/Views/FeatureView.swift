//
//  FeatureView.swift
//  Trouver
//
//  Created by Sagar Punhani on 5/16/21.
//

import SwiftUI

struct FeatureView: View {
    @State private var testFlag = true
    
    var body: some View {
        List {
            Toggle(isOn: $testFlag) {
                Text("Test Feature")
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
