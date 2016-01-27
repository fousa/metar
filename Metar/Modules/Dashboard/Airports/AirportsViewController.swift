//
//  AirportsTableViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

import SwiftDate

protocol AirportsViewControllerDelegate {
    func airportsViewController(controller: AirportsViewController, shouldOpenAirport airport: MTRAirport)
}

class AirportsViewController: UIViewController {

    // MARK: - Privates

    private var initialFetch: Bool = true
    private let service = MTRService()
    private let notificationManager = MTRNotificationManager()
    private var timer: NSTimer!

    // MARK: - Delegate

    var delegate: AirportsViewControllerDelegate?

    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!
    @IBOutlet var lastUpdatedLabel: UILabel!

    // MARK: - Callbacks

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

        refreshUpdatedAtLabel()

        MTRDataManager.sharedInstance.observeAirportUpdates(self) { airports in
            self.airports = airports

            // When there are airports and the updatedAt is nil, we want to initialize
            // the updated at value.
            if !airports.isEmpty && MTRDefaults.updatedAt == nil {
                MTRDefaults.updatedAt = NSDate()
            }

            // We only want to go fetch from the webservice during application
            // launch.
            if self.initialFetch {
                self.initialFetch = false
                self.fetchMetarData()
            }
        }

        notificationManager.observeNotification(withName: UIApplicationWillEnterForegroundNotification) { notification in
            self.fetchMetarData()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "refreshUpdatedAtLabel", userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        timer.invalidate()
        timer = nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let top = CGRectGetMaxY(lastUpdatedLabel.frame) + 20.0
        tableView.contentInset = UIEdgeInsetsMake(top, 0.0, 0.0, 0.0)
    }

    // MARK: - Service

    private func fetchMetarData() {
        let airports = self.airports.map { $0.stationName! }
        guard airports.count > 0 else {
            return
        }

        service.fetchMetars(stations: airports) { error, data in
            let metars: [Metar] = MTRXMLParser(data: data)?.parseMetars() ?? [Metar]()

            if error == nil {
                // When no error occures we set the updated at date.
                MTRDefaults.updatedAt = NSDate()
            }

            for airport in self.airports {
                if let metar = metars.filter({ $0.station.name == airport.stationName }).first {
                    MTRDataManager.sharedInstance.update(airport: airport, withMetar: metar)
                }
            }

            dispatch_async_main {
                self.refreshUpdatedAtLabel()
                self.refreshCells()
            }
        }
    }

    private func refreshCells() {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
        }
    }

    // MARK: - Updated at

    func refreshUpdatedAtLabel() {
        lastUpdatedLabel.text = MTRDefaults.updatedAt?.toNaturalString(NSDate(), style: FormatterStyle(style: .Full, units: nil, max: 2))
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