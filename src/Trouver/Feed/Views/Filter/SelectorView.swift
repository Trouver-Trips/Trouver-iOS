//
//  SelectorView.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import SwiftUI

struct SelectorView<T: RawRepresentable>: View {
    @ObservedObject var viewModel: SelectorOption<T>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(viewModel.title))
            HStack(spacing: 8) {
                ForEach(viewModel.options) { option in
                    Button(action: {
                        viewModel.chooseOption(option: option)
                    }, label: {
                        SegmentView(text: LocalizedStringKey(option.name), isSelected: option.selected)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    })
                }
            }
        }
        .padding()
    }
}

#if DEBUG
struct SelectorViewContainer: View {
    var body: some View {
        SelectorView(viewModel: SelectorOption(
                        title: "difficulty.title",
                        multiSelect: true,
                        options: [
                            .init(name: "difficulty.option.easy", type: Difficulty.easy),
                            .init(name: "difficulty.option.medium", type: Difficulty.medium),
                            .init(name: "difficulty.option.hard", type: Difficulty.hard)
                        ]))
    }
}

struct SelectorViewPreviews: PreviewProvider {
    static var previews: some View {
        SelectorViewContainer()
    }
}
#endif 
