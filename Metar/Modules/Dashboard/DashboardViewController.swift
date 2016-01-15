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
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashboardView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dashboardView.startIntroAnimation {
            self.startUpdatingHeading()
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? PlaceholderViewController {
            controller.delegate = self
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
    
    // MARK: - Actions
    
    @IBAction func addStation(sender: AnyObject) {
        print("🎯 Open search screen")
        
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        storyboard.delegate = self
        let controller = storyboard.instantiateInitialViewController()!
        presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Status bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension DashboardViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let angle = CGFloat(-newHeading.magneticHeading / 180.0 * M_PI)
        dashboardView.rotatePlane(toAngle: angle)
    }
}

extension DashboardViewController: DashboardViewDataSource {
    func numberOfStationsInDashboardView(dashboardView: DashboardView) -> Int {
        return 1
    }
}

extension DashboardViewController: UIStoryboardDelegate {
    func storyboardShouldDismiss(storyboard: UIStoryboard) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension DashboardViewController: PlaceholderViewControllerDelegate {
    func placeholderViewControllerWillAddStation(controller: PlaceholderViewController) {
        addStation(controller)
    }
}