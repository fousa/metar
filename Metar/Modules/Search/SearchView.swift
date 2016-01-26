//
//  SearchView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit
import CoreLocation

protocol SearchViewDelegate: class {
    func searchViewWillUseCurrentLocation(searchView: SearchView)
    func searchViewWillClear(searchView: SearchView)
    func searchView(searchView: SearchView, willOpenMetar metar: Metar)
}

class SearchView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet private var searchField: UISearchBar!
    @IBOutlet private var locationButton: MTRLocationButton!
    @IBOutlet private(set) var tableView: UITableView!
    
    @IBOutlet private var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    weak var delegate: SearchViewDelegate?
    
    var metars = [Metar]()
    var location: CLLocation?

    private let notificationManager = MTRNotificationManager()
    
    var query: String? {
        return searchField.text
    }
    
    // MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set to use the dark keyboard.
        searchField.keyboardAppearance = .Dark

        notificationManager.observeNotification(withName: UIKeyboardWillShowNotification) { notification in
            print("🔑 Show keyboard")
            self.moveSearch(up: true, notification: notification)
        }

        notificationManager.observeNotification(withName: UIKeyboardWillHideNotification) { notification in
            print("🔑 Hide keyboard")
            self.moveSearch(up: false, notification: notification)
        }
    }
    
    // MARK: - Data
    
    func invalidateData() {
        print("📕 Found \(metars.count) metar(s)")
        
        dispatch_async_main {
            self.tableView.hidden = self.metars.isEmpty
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Responder
    
    override func becomeFirstResponder() -> Bool {
        return searchField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return searchField.resignFirstResponder()
    }
    
    // MARK: - Animations
    
    private func moveSearch(up up: Bool, notification: NSNotification) {
        if let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue where up {
            tableBottomConstraint.constant = value.CGRectValue().size.height
            
        } else {
            tableBottomConstraint.constant = 0
        }
        
        if let value = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            UIView.animateWithDuration(value.doubleValue) {
                self.layoutIfNeeded()
            }
        }
    }

    // MARK: - Current location animation

    func startAnimatingLocation() {
        locationButton.startAnimating()
    }

    func stopAnimatingLocation() {
        locationButton.stopAnimating()
    }

    // MARK: - Actions

    @IBAction func searchByLocation(sender: AnyObject) {
        delegate?.searchViewWillUseCurrentLocation(self)
    }

}

extension SearchView: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metars.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Metar") as! SearchMetarTableViewCell // tailor:disable
        cell.configure(withMetar: metars[indexPath.row], currentLocation: location)
        return cell
    }

}

extension SearchView: UITableViewDelegate {

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchField.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.searchView(self, willOpenMetar: metars[indexPath.row])
    }

}