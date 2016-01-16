//
//  SearchViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    
    var searchView: SearchView! { return self.view as! SearchView }
    
    private var timer: NSTimer!
    private var currentSearchQuery: String?
    private let service = MetarService()
    
    private var locationManager: CLLocationManager?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.delegate = self
        title = NSLocalizedString("search_label_title", comment: "")
        
        
        // Setup the location manager.
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "queryStations", userInfo: nil, repeats: true)
        
        searchView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchView.resignFirstResponder()
        timer.invalidate()
    }
    
    // MARK: - Searching
    
    func queryStations() {
        if let searchQuery = searchView.query where searchQuery != currentSearchQuery {
            currentSearchQuery = searchQuery
            print("👀 Search stations with query \(searchQuery)")
            
            service.cancel()
            if searchQuery.isEmpty {
                self.searchView.metars = [Metar]()
                self.searchView.invalidateData()
                return
            }
            
            service.fetchList(station: searchQuery, completion: { (error, data) -> () in
                var metars: [Metar] = MetarXMLParser(data: data)?.parseMetars() ?? [Metar]()
                if let location = self.searchView.location {
                    metars.sortInPlace({ $0.station.location?.distanceFromLocation(location) < $1.station.location?.distanceFromLocation(location) })
                }
                self.searchView.metars = metars
                self.searchView.invalidateData()
            })
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        print("🎯 Dismiss search screen")
        
        storyboard?.dismiss()
    }
    
    // MARK: - Status bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        searchView.location = newLocation
    }
}

extension SearchViewController: SearchViewDelegate {
    func searchViewWillUseCurrentLocation(searchView: SearchView) {
        print("👀 Use current location")
        if let location = searchView.location {
            service.cancel()
            service.fetchList(location: location, completion: { (error, data) -> () in
                var metars: [Metar] = MetarXMLParser(data: data)?.parseMetars() ?? [Metar]()
                metars.sortInPlace({ $0.station.location?.distanceFromLocation(location) < $1.station.location?.distanceFromLocation(location) })
                self.searchView.metars = metars
                self.searchView.invalidateData()
            })
        }
    }
    
    func searchViewWillClear(searchView: SearchView) {
        print("👀 Clear the text field")
        self.searchView.metars = [Metar]()
        self.searchView.invalidateData()
    }
}