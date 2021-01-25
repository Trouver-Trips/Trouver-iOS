//
//  WrappedHStack.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/24/21.
//

import SwiftUI

struct WrappedHStack: View {
    @State private var totalHeight = CGFloat(100)

    var items: [String]

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.items, id: \.self) { item in
                PillView(text: item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > g.size.width {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if self.items.last == item {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if self.items.last == item {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
        .background(GeometryReader {gp -> Color in
            DispatchQueue.main.async {
                // update on next cycle with calculated height of ZStack
                self.totalHeight = gp.size.height
            }
            return Color.clear
        })
    }
}

struct WrappedHStackPreviews: PreviewProvider {
    static var previews: some View {
        WrappedHStack(items: ["mountains", "kids", "water", "views", "gardens"])
    }
}
