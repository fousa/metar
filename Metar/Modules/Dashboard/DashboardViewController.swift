//
//  DashboardViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit
import CoreLocation

class DashboardViewController: UIViewController {
    
    var dashboardView: DashboardView! { return self.view as! DashboardView }
    
    private var locationManager: CLLocationManager?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dashboardView.startIntroAnimation {
            self.startUpdatingHeading()
        }
    }
    
    // MARK: - Heading
    
    private func startUpdatingHeading() {
        print("🌏 Start updating heading")
        
        // Setup the location manager.
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.headingFilter = kCLHeadingFilterNone
        locationManager?.startUpdatingHeading()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
}

extension DashboardViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let angle = CGFloat(-newHeading.magneticHeading / 180.0 * M_PI)
        dashboardView.rotatePlane(toAngle: angle)
    }
}