//
//  TabsContainer.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/30/21.
//

import SwiftUI

struct TabsContainer <Content: View> : View {
    var images: [String]
    let content: Content

    init(images: [String], @ViewBuilder content: () -> Content) {
        self.images = images
        self.content = content()
    }

    @GestureState private var translation: CGFloat = 0
    @State private var index: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    self.content
                    .frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.index) * geometry.size.width)
                .animation(.interactiveSpring())
                .gesture(
                    DragGesture()
                    .updating(self.$translation) { gestureValue, gestureState, _ in
                       gestureState = gestureValue.translation.width
                    }
                    .onEnded { value in
                        let weakGesture: CGFloat = value.translation.width < 0 ? -100 : 100
                        let offset = (value.translation.width + weakGesture) / geometry.size.width
                        let newIndex = (CGFloat(self.index) - offset).rounded()
                        self.index = min(max(Int(newIndex), 0), self.images.count - 1)
                    }
                )
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
                    .padding(.bottom, 80)
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
            TabsContainer(images: images) {
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
