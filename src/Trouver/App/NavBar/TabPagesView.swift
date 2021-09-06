//
//  TabPagesView.swift
//  Trouver
//
//  Created by Sagar Punhani on 5/20/21.
//

import SwiftUI

struct TabPagesView<Content: View>: View {
    @GestureState private var translation: CGFloat = 0
    @Binding private var index: Int
    @Binding private var disableGesture: Bool
    
    private let width: CGFloat
    private let maxIndex: Int
    private let content: Content
    private let useWeakGesture: Bool

    init(width: CGFloat,
         index: Binding<Int>,
         maxIndex: Int,
         useWeakGesture: Bool = false,
         disableGesture: Binding<Bool> = .constant(false),
         @ViewBuilder
         content: () -> Content) {
        self.init(width: width,
                  index: index,
                  maxIndex: maxIndex,
                  useWeakGesture: useWeakGesture,
                  disableGesture: disableGesture,
                  content: content())
    }
    
    init(width: CGFloat,
         index: Binding<Int>,
         maxIndex: Int,
         useWeakGesture: Bool = false,
         disableGesture: Binding<Bool> = .constant(false),
         content: Content) {
        self.width = width
        self._index = index
        self.maxIndex = maxIndex
        self.useWeakGesture = useWeakGesture
        self._disableGesture = disableGesture
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0) {
            self.content
            .frame(width: width)
        }
        .frame(width: width, alignment: .leading)
        .offset(x: -CGFloat(self.index) * width)
        .animation(.interactiveSpring())
        .gesture(
            
            DragGesture()
                .updating(self.$translation) { gestureValue, gestureState, _ in
                   gestureState = gestureValue.translation.width
                }
                .onEnded { value in
                    if disableGesture { return }
                    let weakGesture: CGFloat = useWeakGesture ? (value.translation.width < 0 ? -100 : 100) : 0
                    let offset = (value.translation.width + weakGesture) / width
                    let newIndex = (CGFloat(self.index) - offset).rounded()
                    self.index = min(max(Int(newIndex), 0), self.maxIndex)
                }
        )
    }
}

#if DEBUG
struct TabPagesViewPreviews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            TabPagesView(width: geo.size.width,
                         index: Binding.constant(0),
                         maxIndex: 3) {
                EmptyView()
            }
        }
    }
}
#endif
