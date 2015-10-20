
//
//  SearchView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

protocol SearchViewDelegate {
    func searchViewWillUseCurrentLocation(searchView: SearchView)
}

class SearchView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet private var keyboardTapGesture: UITapGestureRecognizer!
    
    @IBOutlet private var searchField: UISearchBar!
    @IBOutlet private var searchButton: UIButton!
    
    @IBOutlet private var searchButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    var delegate: SearchViewDelegate?
    
    private var keyboardShowNotification: AnyObject!
    private var keyboardHideNotification: AnyObject!
    
    // MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        keyboardShowNotification = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] notification in
            print("🔑 Show keyboard")
            self.keyboardTapGesture.enabled = true
            self.moveSearch(up: true, notification: notification)
        }
        keyboardHideNotification = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] notification in
            print("🔑 Hide keyboard")
            self.keyboardTapGesture.enabled = false
            self.moveSearch(up: false, notification: notification)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(keyboardShowNotification)
        NSNotificationCenter.defaultCenter().removeObserver(keyboardHideNotification)
    }
    
    // MARK: - Responder
    
    override func resignFirstResponder() -> Bool {
        return searchField.resignFirstResponder()
    }
    
    // MARK: - Animations
    
    private func moveSearch(up up: Bool, notification: NSNotification) {
        if let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue where up {
            self.searchButtonBottomConstraint.constant = value.CGRectValue().size.height
            
        } else {
            self.searchButtonBottomConstraint.constant = 0
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
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Location") as UITableViewCell!
        return cell
    }
}

extension SearchView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.searchViewWillUseCurrentLocation(self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}