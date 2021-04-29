//
//  LocationProvider.swift
//  Trouver
//
//  Created by Sagar Punhani on 4/14/21.
//

import Foundation
import CoreLocation
import Combine

/// Only finds the location one time until it becomes nil
class LocationProvider: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let defaultLocation = CLLocationCoordinate2D(latitude: 47.6062,
                                                        longitude: -122.3321)

    private let locationManager = CLLocationManager()
    private var locationFound: Bool { lastLocation != nil }
    private var locationStatus: CLAuthorizationStatus? {
        didSet {
            if let status = locationStatus, status == .denied || status == .restricted {
                self.lastLocation = nil
            }
        }
    }
    
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, !locationFound else { return }
        lastLocation = location
    }
}
