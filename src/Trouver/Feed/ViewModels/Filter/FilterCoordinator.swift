//
//  FilterSelections.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/4/21.
//

import Combine
import CoreGraphics

class FilterCoordinator: ObservableObject {
    private var bag = Set<AnyCancellable>()
    
    let sortSelector: SelectorOption<SortType>
    let difficultySelector: SelectorOption<Difficulty>
    let lengthSlider: SliderOption
    let elevationSlider: SliderOption
    
    @Published var filterOptions: FilterOptions
        
    init(width: CGFloat) {
        let options = FilterOptions()
        filterOptions = FilterOptions()
        
        sortSelector = SelectorOption(title: "sort.title",
                                      multiSelect: false,
                                      options: [
                                        .init(name: "sort.option.closest",
                                              selected: options.sort == .closest,
                                              type: SortType.closest),
                                        .init(name: "sort.option.popular",
                                              selected: options.sort == .popularity,
                                              type: SortType.popularity)
                                      ])
        
        difficultySelector = SelectorOption(title: "difficulty.title",
                                            multiSelect: true,
                                            options: [
                                                .init(name: "difficulty.option.easy",
                                                      type: Difficulty.easy),
                                                .init(name: "difficulty.option.moderate",
                                                      type: Difficulty.moderate),
                                                .init(name: "difficulty.option.hard",
                                                      type: Difficulty.hard)
                                            ])
        
        lengthSlider = SliderOption(title: "length.title",
                                    units: .miles,
                                    start: 0,
                                    end: Double.feetPerMile * 50,
                                    width: width)
        
        elevationSlider = SliderOption(title: "elevation.title",
                                       units: .feet,
                                       start: 0,
                                       end: 10_000,
                                       width: width)
        
        updateOptions()
    }
    
    deinit {
        bag.forEach { $0.cancel() }
    }
    
    private func updateOptions() {
        sortSelector.$options.sink(receiveValue: { [weak self] options in
            self?.filterOptions.sort = options.first(where: { $0.selected })?.type ?? .closest
        })
        .store(in: &bag)
        
        difficultySelector.$options.sink(receiveValue: { [weak self] options in
            self?.filterOptions.difficulty =
                options
                .filter { $0.selected }
                .map { $0.type }
        })
        .store(in: &bag)
        
        lengthSlider.slider.lowHandle.$currentValue.sink(receiveValue: { [weak self] value in
            self?.filterOptions.lengthMin = Int(value)
        })
        .store(in: &bag)
        
        lengthSlider.slider.highHandle.$currentValue.sink(receiveValue: { [weak self] value in
            self?.filterOptions.lengthMax = Int(value)
        })
        .store(in: &bag)
        
        elevationSlider.slider.lowHandle.$currentValue.sink(receiveValue: { [weak self] value in
            self?.filterOptions.elevationMin = Int(value)
        })
        .store(in: &bag)
        
        elevationSlider.slider.highHandle.$currentValue.sink(receiveValue: { [weak self] value in
            self?.filterOptions.elevationMax = Int(value)
        })
        .store(in: &bag)
    }
}
