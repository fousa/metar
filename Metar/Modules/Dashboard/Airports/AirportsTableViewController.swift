//
//  AirportsTableViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

protocol AirportsTableViewControllerDelegate {
    func airportsTableViewController(controller: AirportsTableViewController, shouldOpenAirport airport: MTRAirport)
}

class AirportsTableViewController: UITableViewController {

    var delegate: AirportsTableViewControllerDelegate?

    var airports = [MTRAirport]() {
        didSet {
            if airports.count > 0 {
                MTRLocationManager.sharedInstance.startUpdatingLocation()
            }
            tableView.reloadData()
        }
    }

    // MARK: - View flow

    override func viewDidLoad() {
        super.viewDidLoad()

        MTRDataManager.sharedInstance.observeAirportUpdates(self) { airports in
            self.airports = airports
        }
    }

    // MARK: - DataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airports.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Airport") as! AirportsTableViewCell // tailor:disable
        cell.configure(withAirport: airports[indexPath.row], currentLocation: MTRLocationManager.sharedInstance.currentLocation)
        return cell
    }

    // MARK: - Delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let airport = airports[indexPath.row]
        delegate?.airportsTableViewController(self, shouldOpenAirport: airport)
    }

}