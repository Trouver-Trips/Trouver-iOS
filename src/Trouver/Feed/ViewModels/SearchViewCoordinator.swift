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
        self.representable.resultsViewController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.country = "USA"
        self.representable.resultsViewController.autocompleteFilter = filter
        
        self.searchController = UISearchController(searchResultsController:
                                                    self.representable.resultsViewController)
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        super.init()
        representable.resultsViewController.delegate = self
        self.searchController.searchResultsUpdater = self.representable.resultsViewController
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        self.representable.onSearchButtonClicked(place.coordinate)
        self.searchController.dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error) {
        Logger.logError("Error with results", error: error)
    }
}
