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
                                                    UInt(GMSPlaceField.coordinate.rawValue) |
                                                    UInt(GMSPlaceField.addressComponents.rawValue))
        self.representable.resultsViewController.placeFields = fields
        
        self.searchController = UISearchController(searchResultsController:
                                                    self.representable.resultsViewController)
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        super.init()
        representable.resultsViewController.delegate = self
        self.searchController.searchResultsUpdater = self.representable.resultsViewController
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        var state = USState.unknown
        place.addressComponents?.forEach({ comp in
            if comp.types.contains("administrative_area_level_1") {
                state = USState(rawValue: comp.name.lowercased()) ?? .unknown
            }
        })
        self.representable.onSearchButtonClicked(place.coordinate, state)
        self.searchController.dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error) {
        Logger.logError("Error with results", error: error)
    }
}
