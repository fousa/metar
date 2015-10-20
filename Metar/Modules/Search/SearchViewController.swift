//
//  SearchViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchView: SearchView! { return self.view as! SearchView }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func search(sender: AnyObject) {
        print("👀 Search stations")
    }
    
    @IBAction func close(sender: AnyObject) {
        print("🎯 Dismiss search screen")
        
        storyboard?.dismiss()
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        searchView.resignFirstResponder()
    }
}

extension SearchViewController: SearchViewDelegate {
    func searchViewWillUseCurrentLocation(searchView: SearchView) {
        print("👀 Use current location")
    }
}