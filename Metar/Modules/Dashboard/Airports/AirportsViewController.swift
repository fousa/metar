//
//  AirportsTableViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

protocol AirportsViewControllerDelegate {
    func airportsViewController(controller: AirportsViewController, shouldOpenAirport airport: MTRAirport)
}

class AirportsViewController: UIViewController {

    private var initialFetch: Bool = true
    private let service = MTRService()
    private let notificationManager = MTRNotificationManager()

    var delegate: AirportsViewControllerDelegate?

    @IBOutlet var tableView: UITableView!

    var airports = [MTRAirport]() {
        didSet {
            if airports.count > 0 {
                MTRLocationManager.sharedInstance.startUpdatingLocation()
            }
            tableView.reloadData()
        }
    }

    // MARK: - Init

    deinit {
        MTRDataManager.sharedInstance.removeAirportUpdatesObserver(self)
    }

    // MARK: - View flow

    override func viewDidLoad() {
        super.viewDidLoad()

        MTRDataManager.sharedInstance.observeAirportUpdates(self) { airports in
            self.airports = airports
            if self.initialFetch {
                self.initialFetch = false
                self.fetchMetarData()
            }
        }

        notificationManager.observeNotification(withName: UIApplicationWillEnterForegroundNotification) { notification in
            self.fetchMetarData()
        }
    }

    // MARK: - Service

    private func fetchMetarData() {
        let airports = self.airports.map { $0.stationName! }
        guard airports.count > 0 else {
            return
        }

        service.fetchMetars(stations: airports) { error, data in
            let metars: [Metar] = MTRXMLParser(data: data)?.parseMetars() ?? [Metar]()

            for airport in self.airports {
                if let metar = metars.filter({ $0.station.name == airport.stationName }).first {
                    MTRDataManager.sharedInstance.update(airport: airport, withMetar: metar)
                }
            }

            dispatch_async_main {
                self.refreshCells()
            }
        }
    }

    private func refreshCells() {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
        }
    }

}

extension AirportsViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airports.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Airport") as! AirportsTableViewCell // tailor:disable
        cell.configure(withAirport: airports[indexPath.row], currentLocation: MTRLocationManager.sharedInstance.currentLocation)
        return cell
    }

}

extension AirportsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let airport = airports[indexPath.row]
        delegate?.airportsViewController(self, shouldOpenAirport: airport)
    }

}