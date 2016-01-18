//
//  MTRLocationManager.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 18/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import Foundation
import CoreLocation

let MTRHeadingUpdatedNotification = "MTRHeadingUpdatedNotification"
let MTRLocationUpdatedNotification = "MTRLocationUpdatedNotification"

class MTRLocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager
    
    static let sharedInstance = MTRLocationManager()
    
    // MARK: - Getters
    
    var currentLocation: CLLocation? {
        return locationManager.location
    }
    
    // MARK: - Init
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.headingFilter = kCLHeadingFilterNone
    }
    
    // MARK: - Start
    
    func startUpdatingHeading() {
        print("🌏 Start updating heading")
        locationManager.startUpdatingHeading()
    }
    
    func startUpdatingLocation() {
        print("🌏 Start updating location")
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        NSNotificationCenter.defaultCenter().postNotificationName(MTRHeadingUpdatedNotification, object: newHeading)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        NSNotificationCenter.defaultCenter().postNotificationName(MTRLocationUpdatedNotification, object: newLocation)
    }

}
