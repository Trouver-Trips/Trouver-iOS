//
//  NavigationSearch.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/30/21.
//

import SwiftUI
import GooglePlaces

extension View {
    func navigationSearch(onSearchButtonClicked: @escaping () -> Void = {}) -> some View {
        overlay(SearchView(onSearchButtonClicked: onSearchButtonClicked)
                    .frame(width: 0, height: 0))
    }
}

struct SearchView: UIViewControllerRepresentable {
    typealias UIViewControllerType = Wrapper
    
    private let onSearchButtonClicked: () -> Void
    
    private var resultsViewController: GMSAutocompleteResultsViewController = GMSAutocompleteResultsViewController()
    
    init(onSearchButtonClicked: @escaping () -> Void = {}) {
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
        wrapper.navigationBarSizeToFit()
        
    }
    
    class Coordinator: NSObject,
                       GMSAutocompleteResultsViewControllerDelegate {
        
        let representable: SearchView
        
        let searchController: UISearchController
        
        init(representable: SearchView) {
            self.representable = representable
            
            // Specify the place data types to return.
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))
            self.representable.resultsViewController.placeFields = fields
            
            self.searchController = UISearchController(searchResultsController:
                                                        self.representable.resultsViewController)
            
            super.init()
            representable.resultsViewController.delegate = self
            self.searchController.searchResultsUpdater = self.representable.resultsViewController
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didAutocompleteWith place: GMSPlace) {
            Logger.logInfo(place.name ?? "no name")
            self.searchController.dismiss(animated: true, completion: nil)
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
