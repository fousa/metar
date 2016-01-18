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

class MTRLocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager
    
    static let sharedInstance = MTRLocationManager()
    
    // MARK: - Init
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.headingFilter = kCLHeadingFilterNone
    }
    
    func startUpdatingHeading() {
        print("🌏 Start updating heading")
        locationManager.startUpdatingHeading()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        NSNotificationCenter.defaultCenter().postNotificationName(MTRHeadingUpdatedNotification, object: newHeading)
    }
}