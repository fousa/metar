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
        title = NSLocalizedString("search_label_title", comment: "")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchView.resignFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func search(sender: AnyObject) {
        if let stationQuery = searchView.query {
            print("👀 Search stations with query \(stationQuery)")
            
            MetarService().fetchList(station: stationQuery, completion: { (error, data) -> () in
                let metars: [Metar]? = MetarXMLParser(data: data)?.parseMetars()
                self.searchView.metars = metars ?? [Metar]()
                self.searchView.invalidateData()
            })
        } else {
            print("👀 Search no stations")
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        print("🎯 Dismiss search screen")
        
        storyboard?.dismiss()
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        searchView.resignFirstResponder()
    }
    
    // MARK: - Status bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension SearchViewController: SearchViewDelegate {
    func searchViewWillUseCurrentLocation(searchView: SearchView) {
        print("👀 Use current location")
    }
    
    func searchViewWillClear(searchView: SearchView) {
        print("👀 Clear the text field")
        self.searchView.metars = [Metar]()
        self.searchView.invalidateData()

    }
}