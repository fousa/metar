
//
//  SearchView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class SearchView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet private var searchField: UISearchBar!
    @IBOutlet private var searchButton: UIButton!
    
    @IBOutlet private var searchButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            print("🔑 Show keyboard")
            self.moveSearch(up: true, notification: notification)
        }
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            print("🔑 Hide keyboard")
            self.moveSearch(up: false, notification: notification)
        }
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
