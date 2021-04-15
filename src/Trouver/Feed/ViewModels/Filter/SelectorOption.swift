//
//  SelectorOption.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import Combine
import Foundation

class SelectorOption<T: RawRepresentable>: ObservableObject {
    struct Option<U: RawRepresentable>: Identifiable, Equatable {
        static func == (lhs: SelectorOption<T>.Option<U>, rhs: SelectorOption<T>.Option<U>) -> Bool {
            lhs.name == rhs.name
        }
        
        let name: String

        var id: UUID { UUID() }
        var selected = false
        var type: U
    }
    
    let title: String
    let multiSelect: Bool
    
    @Published var options: [Option<T>]

    init(title: String, multiSelect: Bool, options: [Option<T>]) {
        self.title = title
        self.multiSelect = multiSelect
        self.options = options
    }
        
    func chooseOption(option: Option<T>) {
        let optionIndex = options.firstIndex(of: option) ?? -1
        if !multiSelect {
            options.indices.forEach {
                options[$0].selected = $0 == optionIndex
            }
        } else {
            options[optionIndex].selected.toggle()
        }
    }
}
