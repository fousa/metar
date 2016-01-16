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
    
    private var timer: NSTimer!
    private var currentSearchQuery: String?
    private let service = MetarService()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.delegate = self
        title = NSLocalizedString("search_label_title", comment: "")
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
                let metars: [Metar]? = MetarXMLParser(data: data)?.parseMetars()
                self.searchView.metars = metars ?? [Metar]()
                self.searchView.invalidateData()
            })
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