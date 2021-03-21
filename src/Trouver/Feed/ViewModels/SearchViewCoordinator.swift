//
//  SearchViewCoordinator.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/31/21.
//

import SwiftUI
import GooglePlaces

class SearchViewCoordinator: NSObject,
                             GMSAutocompleteResultsViewControllerDelegate {
    
    private let representable: SearchView
    
    let searchController: UISearchController
    
    init(representable: SearchView) {
        self.representable = representable
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue:
                                                    UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.placeID.rawValue) |
                                                    UInt(GMSPlaceField.coordinate.rawValue))
        representable.resultsViewController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.country = "USA"
        representable.resultsViewController.autocompleteFilter = filter
        
        searchController = UISearchController(searchResultsController:
                                                    representable.resultsViewController)
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        super.init()
        representable.resultsViewController.delegate = self
        searchController.searchResultsUpdater = representable.resultsViewController
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        representable.onSearchButtonClicked(place.coordinate)
        searchController.dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error) {
        Logger.logError("Error with results", error: error)
    }
}
