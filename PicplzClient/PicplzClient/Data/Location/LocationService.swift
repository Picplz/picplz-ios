//
//  LocationService.swift
//  PicplzClient
//
//  Created by 임영택 on 4/5/25.
//

import Foundation
import MapKit
import Combine
import OSLog

protocol LocationService {
    var currentLocationPubisher: PassthroughSubject<CLLocation, Never> { get }
    var currentLocation: CLLocation? { get }
}

final class LocationServiceImpl: NSObject, LocationService {
    private(set) var currentLocationPubisher: PassthroughSubject<CLLocation, Never>
    var currentLocation: CLLocation? {
        locationManager.location
    }

    private let locationManager: CLLocationManager
    private let log = Logger.of("LocationServiceImpl")

    init(locationManager: CLLocationManager = .init()) {
        self.locationManager = locationManager
        self.currentLocationPubisher = .init()
        super.init()

        self.locationManager.delegate = self
        checkAuthorization()
    }

    private func checkAuthorization() {
        if locationManager.authorizationStatus == .authorizedWhenInUse,
           let location = locationManager.location {
            currentLocationPubisher.send(location)
        } else if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            print("\(String(describing: locationManager.authorizationStatus))")
        }
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse,
           let currentLocation = manager.location {
            currentLocationPubisher.send(currentLocation)
        } else if status == .notDetermined {
            log.info("could not get current location because of status. status=\(String(describing: status))")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count >= 1 {
            log.info("didUpdateLocations - the number of elements is more than one. Whole locations list - \(locations)")
        }

        if let firstLocation = locations.first {
            currentLocationPubisher.send(firstLocation)
        }
    }
}
