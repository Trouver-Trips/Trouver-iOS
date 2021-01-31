//
//  NavigationSearch.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/30/21.
//

import SwiftUI
import GooglePlaces

extension View {
    func navigationSearch(text: Binding<String>,
                          onSearchButtonClicked: @escaping () -> Void = {},
                          onCancelButtonClicked: @escaping () -> Void = {}) -> some View {
        overlay(NavigationSearch(text: text,
                                 onSearchButtonClicked: onSearchButtonClicked,
                                 onCancelButtonClicked: onCancelButtonClicked)
                    .frame(width: 0, height: 0))
    }
}

struct NavigationSearch: UIViewControllerRepresentable {
    typealias UIViewControllerType = Wrapper
    
    @Binding private var text: String
    
    private let onSearchButtonClicked: () -> Void
    private let onCancelButtonClicked: () -> Void
    
    private var resultsViewController: GMSAutocompleteResultsViewController = GMSAutocompleteResultsViewController()
    
    init(text: Binding<String>,
         onSearchButtonClicked: @escaping () -> Void = {},
         onCancelButtonClicked: @escaping () -> Void = {}) {
        self._text = text
        self.onCancelButtonClicked = onCancelButtonClicked
        self.onSearchButtonClicked = onSearchButtonClicked
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(representable: self)
    }

    func makeUIViewController(context: Context) -> Wrapper {
        Wrapper()
    }
    
    func updateUIViewController(_ wrapper: Wrapper, context: Context) {
        wrapper.searchController = context.coordinator.searchController
        wrapper.searchController?.searchBar.text = text
        wrapper.navigationBarSizeToFit()
        
    }
    
    class Coordinator: NSObject, UISearchResultsUpdating, UISearchBarDelegate, GMSAutocompleteResultsViewControllerDelegate {
        
        let representable: NavigationSearch
        
        let searchController: UISearchController
        
        init(representable: NavigationSearch) {
            self.representable = representable
            
            // Specify the place data types to return.
                let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                  UInt(GMSPlaceField.placeID.rawValue))
            self.representable.resultsViewController.placeFields = fields
            

            self.searchController = UISearchController(searchResultsController: self.representable.resultsViewController)
            
            super.init()
            representable.resultsViewController.delegate = self
            self.searchController.searchResultsUpdater = self.representable.resultsViewController
            self.searchController.searchBar.delegate = self
            self.searchController.searchBar.text = representable.text
        }
        
        // MARK: - UISearchResultsUpdating
        func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
            DispatchQueue.main.async { [weak self] in self?.representable.text = text }
        }
        
        // MARK: - UISearchBarDelegate
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            DispatchQueue.main.async { self.representable.onCancelButtonClicked() }
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            DispatchQueue.main.async { self.representable.onSearchButtonClicked() }
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didAutocompleteWith place: GMSPlace) {
            Logger.logInfo(place.name ?? "no name")
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didFailAutocompleteWithError error: Error) {
            Logger.logError("Error with results", error: error)
        }
    }
    
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
