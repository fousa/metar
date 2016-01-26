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
    
    var searchView: SearchView! { return self.view as! SearchView } // tailor:disable
    var spinnerBarButton: MTRSpinnerBarButtonItem! { return self.navigationItem.leftBarButtonItem as! MTRSpinnerBarButtonItem } // tailor:disable
    
    private var timer: NSTimer!
    private var currentSearchQuery: String?
    private let service = MTRService()
    private let notificationManager = MTRNotificationManager()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.delegate = self
        title = NSLocalizedString("search_label_title", comment: "")
        searchView.becomeFirstResponder()
        
        // Setup the location manager.
        MTRLocationManager.sharedInstance.startUpdatingLocation()
        startUpdatingLocation()
        
        // Add spinner bar button view.
        navigationItem.leftBarButtonItem =  MTRSpinnerBarButtonItem(color: UIColor.whiteColor())
        
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "queryStations", userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchView.endEditing(true)
        timer.invalidate()
    }
    
    // MARK: - Location
    
    private func startUpdatingLocation() {
        notificationManager.observeNotification(withName: MTRLocationUpdatedNotification) { notification in
            if let location = notification.object as? CLLocation {
                self.searchView.location = location
            }
        }
    }
    
    // MARK: - Searching
    
    func queryStations() {
        if let searchQuery = searchView.query where searchQuery != currentSearchQuery {
            currentSearchQuery = searchQuery
            print("👀 Search stations with query \(searchQuery)")
            
            service.cancel()
            if searchQuery.isEmpty {
                self.searchView.metars = [Metar]()
                spinnerBarButton.stopAnimating()
                self.searchView.invalidateData()
                return
            }
            
            spinnerBarButton.startAnimating()
            service.fetchMetars(station: searchQuery, completion: { (error, data) -> () in
                var metars: [Metar] = MTRXMLParser(data: data)?.parseMetars() ?? [Metar]()
                if let location = self.searchView.location {
                    metars.sortInPlace({ $0.station.location?.distanceFromLocation(location) < $1.station.location?.distanceFromLocation(location) })
                }
                self.searchView.metars = metars
                dispatch_async_main { self.spinnerBarButton.stopAnimating() }
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

extension SearchViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard searchView.metars.count > 0 else {
            return nil
        }

        let cellPosition = searchView.tableView.convertPoint(location, fromView: searchView)        
        guard let indexPath = searchView.tableView.indexPathForRowAtPoint(cellPosition), let cell = searchView.tableView.cellForRowAtIndexPath(indexPath) else {
            return nil
        }
        
        let metar = searchView.metars[indexPath.row]
        print("🎯 Peeking at \(metar.station.name)")

        let previewFrame = searchView.tableView.convertRect(cell.frame, toView: searchView)
        previewingContext.sourceRect = previewFrame
        
        let storyboard = UIStoryboard(name: "Metar", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as! MetarViewController // tailor:disable
        controller.metar = metar
        return controller
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: false)
    }

}

extension SearchViewController: SearchViewDelegate {

    func searchView(searchView: SearchView, willOpenMetar metar: Metar) {
        print("🎯 Open metar detail for \(metar.station.name)")
        
        let storyboard = UIStoryboard(name: "Metar", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as! MetarViewController // tailor:disable
        controller.metar = metar
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func searchViewWillUseCurrentLocation(searchView: SearchView) {
        print("👀 Use current location")
        if let location = searchView.location {
            service.cancel()
            searchView.startAnimatingLocation()
            service.fetchMetars(location: location, completion: { (error, data) -> () in
                var metars: [Metar] = MTRXMLParser(data: data)?.parseMetars() ?? [Metar]()
                metars.sortInPlace({ $0.station.location?.distanceFromLocation(location) < $1.station.location?.distanceFromLocation(location) })
                self.searchView.metars = metars
                dispatch_async_main { self.searchView.stopAnimatingLocation() }
                
                self.searchView.invalidateData()
            })
        }
    }
    
    func searchViewWillClear(searchView: SearchView) {
        print("👀 Clear the text field")
        searchView.metars = [Metar]()
        spinnerBarButton.stopAnimating()
        searchView.invalidateData()
    }
    
}