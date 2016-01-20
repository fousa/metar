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
    var dashboardView: DashboardView! { return self.view as! DashboardView } // tailor:disable
    
    var shortcutItem: UIApplicationShortcutItem?

    private let notificationManager = MTRNotificationManager()
    private var airports = [MTRAirport]()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashboardView.dataSource = self

        MTRDataManager.sharedInstance.observeAirportUpdates(self) { airports in
            print("🗼 Airports fetched \(airports.count)")
            self.airports = airports
        }
        MTRLocationManager.sharedInstance.startUpdatingHeading()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dashboardView.startIntroAnimation {
            self.observeHeadingUpdating()
            
            // When started from the shortcut open the search screen.
            if let shortcutItem = self.shortcutItem {
                self.addStation(shortcutItem)
                self.shortcutItem = nil
            }
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? PlaceholderViewController {
            controller.delegate = self
        } else if let controller = segue.destinationViewController as? AirportsTableViewController {
            controller.delegate = self
        }
    }
    
    // MARK: - Heading
    
    private func observeHeadingUpdating() {
        notificationManager.observeNotification(withName: MTRHeadingUpdatedNotification) { notification in
            if let heading = notification.object as? CLHeading {
                let angle = CGFloat(-heading.magneticHeading / 135.0 * M_PI)
                self.dashboardView.rotatePlane(toAngle: angle)
            }
        }
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

extension DashboardViewController: AirportsTableViewControllerDelegate {

    func airportsTableViewController(controller: AirportsTableViewController, shouldOpenAirport airport: MTRAirport) {
        print("🎯 Open airport detail for \(airport.stationName)")

        let storyboard = UIStoryboard(name: "Metar", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as! MetarViewController // tailor:disable
        controller.airport = airport
        let navigationController = MTRDelegatingNavigationController(rootViewController: controller)
        presentViewController(navigationController, animated: true, completion: nil)
    }

}

extension DashboardViewController: DashboardViewDataSource {

    func numberOfStationsInDashboardView(dashboardView: DashboardView) -> Int {
        return airports.count
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