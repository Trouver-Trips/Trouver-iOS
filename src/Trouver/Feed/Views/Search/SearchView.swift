//
//  NavigationSearch.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/30/21.
//

import SwiftUI
import GooglePlaces

extension View {
    func searchView(onSearchButtonClicked: @escaping (CLLocationCoordinate2D) -> Void = {_  in })
        -> some View {
        overlay(SearchView(onSearchButtonClicked: onSearchButtonClicked)
                    .frame(width: 0, height: 0))
    }
}

struct SearchView: UIViewControllerRepresentable {
    typealias UIViewControllerType = Wrapper
    
    let onSearchButtonClicked: (CLLocationCoordinate2D) -> Void
    let resultsViewController: GMSAutocompleteResultsViewController = GMSAutocompleteResultsViewController()
    
    init(onSearchButtonClicked: @escaping (CLLocationCoordinate2D) -> Void = {_ in }) {
        self.onSearchButtonClicked = onSearchButtonClicked
    }
    
    func makeCoordinator() -> SearchViewCoordinator {
        Coordinator(representable: self)
    }

    func makeUIViewController(context: Context) -> Wrapper {
        Wrapper()
    }
    
    func updateUIViewController(_ wrapper: Wrapper, context: Context) {
        wrapper.searchController = context.coordinator.searchController
        wrapper.navigationBarSizeToFit()
    }
}

// MARK: - Wrapper

/// Used to wrap Search View Controller
extension SearchView {
    class Wrapper: UIViewController {
        var searchController: UISearchController? {
            get {
                parent?.navigationItem.searchController
            }
            set {
                parent?.navigationItem.searchController = newValue
            }
        }
        
        func navigationBarSizeToFit() {
            parent?.navigationController?.navigationBar.sizeToFit()
        }
    }
}
