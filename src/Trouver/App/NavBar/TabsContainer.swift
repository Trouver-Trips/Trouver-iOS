//
//  TabsContainer.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/30/21.
//

import SwiftUI

// Inspired from here: https://betterprogramming.pub/custom-tab-views-in-swiftui-6ef06bf2db73
struct TabsContainer<Content: View> : View {
    private let tabBarBottomMargin: CGFloat = 16
    
    @Binding private var shouldHideNavBar: Bool
    
    private let images: [String]
    private let content: Content

    init(images: [String], shouldHideNavBar: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.images = images
        self._shouldHideNavBar = shouldHideNavBar
        self.content = content()
    }

    @State private var index: Int = 0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                TabPagesView(width: geo.size.width,
                             index: $index,
                             maxIndex: self.images.count - 1,
                             disableGesture: $shouldHideNavBar,
                             content: content)
                if !shouldHideNavBar {
                    VStack {
                        Spacer()
                        HStack {
                            ForEach(0..<images.count) { index in
                                Button(action: {
                                    self.index = index
                                }, label: {
                                    TabBarItem(systemIconName: self.images[index], isHighlighted: self.index == index)
                                })
                            }
                        }
                        .padding(.vertical)
                        .background(Color("TabBarBackground").shadow(radius: 2))
                        .clipShape(Capsule())
                        .padding(.bottom, tabBarBottomMargin)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct TabsContainerPreviews: PreviewProvider {
    static let images = ["magnifyingglass.circle.fill",
                         "viewfinder.circle.fill",
                         "book.circle.fill",
                         "person.circle.fill"]
    
    static var previews: some View {
        ZStack (alignment: .bottom) {
            Color.white
            TabsContainer(images: images, shouldHideNavBar: .constant(false)) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.green.opacity(0.3))
                    .padding()
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.yellow.opacity(0.3))
                    .padding()
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.red.opacity(0.3))
                    .padding()
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.blue.opacity(0.3))
                    .padding()
            }.frame(width: 350, height: 500)
        }
    }
}
#endif
