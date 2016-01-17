
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
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet private var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    weak var delegate: SearchViewDelegate?
    
    var metars = [Metar]()
    var location: CLLocation?
    
    private var keyboardShowNotification: AnyObject!
    private var keyboardHideNotification: AnyObject!
    
    var query: String? {
        return searchField.text
    }
    
    // MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set to use the dark keyboard.
        searchField.keyboardAppearance = .Dark
        
        keyboardShowNotification = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] notification in
            print("🔑 Show keyboard")
            self.moveSearch(up: true, notification: notification)
        }
        keyboardHideNotification = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] notification in
            print("🔑 Hide keyboard")
            self.moveSearch(up: false, notification: notification)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(keyboardShowNotification)
        NSNotificationCenter.defaultCenter().removeObserver(keyboardHideNotification)
    }
    
    // MARK: - Data
    
    func invalidateData() {
        print("📕 Found \(self.metars.count) metar(s)")
        
        dispatch_async_main {
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
}

extension SearchView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // When no metars are available, show the 'use current location' cell.
        return metars.count > 0 ? metars.count : 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return metars.count > 0 ? 44.0 : 51.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if metars.count > 0 {
            return self.tableView(tableView, metarCellForRowAtIndexPath: indexPath)
        } else {
            return self.tableView(tableView, locationCellForRowAtIndexPath: indexPath)
        }
    }
    
    private func tableView(tableView: UITableView, locationCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Location") as UITableViewCell!
        return cell
    }
    
    private func tableView(tableView: UITableView, metarCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Metar") as! SearchMetarTableViewCell
        cell.configure(withMetar: metars[indexPath.row], currentLocation: location)
        return cell
    }
}

extension SearchView: UITableViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchField.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if metars.count == 0 {
            delegate?.searchViewWillUseCurrentLocation(self)
        } else {
            delegate?.searchView(self, willOpenMetar: metars[indexPath.row])
        }
    }
}