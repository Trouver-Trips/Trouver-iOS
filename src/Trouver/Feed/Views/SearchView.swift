//
//  NavigationSearch.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/30/21.
//

import SwiftUI
import GooglePlaces

extension View {
    func searchView(onSearchButtonClicked: @escaping (CLLocationCoordinate2D, USState) -> Void = {_, _  in })
        -> some View {
        overlay(SearchView(onSearchButtonClicked: onSearchButtonClicked)
                    .frame(width: 0, height: 0))
    }
}

struct SearchView: UIViewControllerRepresentable {
    typealias UIViewControllerType = Wrapper
    
    let onSearchButtonClicked: (CLLocationCoordinate2D, USState) -> Void
    let resultsViewController: GMSAutocompleteResultsViewController = GMSAutocompleteResultsViewController()
    
    init(onSearchButtonClicked: @escaping (CLLocationCoordinate2D, USState) -> Void = {_, _  in }) {
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
                self.parent?.navigationItem.searchController
            }
            set {
                self.parent?.navigationItem.searchController = newValue
            }
        }
        
        func navigationBarSizeToFit() {
            self.parent?.navigationController?.navigationBar.sizeToFit()
        }
    }
}
