//
//  MTRService.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import Foundation
import CoreLocation

class MTRService: NSObject {
    
    // MARK: - Properties
    
    typealias ServiceCompletionBlock = (error: NSError?, data: NSData?) -> ()
    
    private var configuration: NSURLSessionConfiguration
    private var session: NSURLSession?
    
    private let BaseURLString: String = "https://aviationweather.gov/adds/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&mostRecentForEachStation=true&hoursBeforeNow=4&"
    
    // MARK: - Init
    
    override init() {
        configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        super.init()
    }
    
    // MARK: - Cancel
    
    func cancel() {
        session?.invalidateAndCancel()
    }
    
    // MARK: - Fetching

    private func fetch(query query: String, completion: ServiceCompletionBlock) {
        let urlString = NSString(format: "%@%@", BaseURLString, query)
        let url = NSURL(string: urlString as String)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let task = session!.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let error = error {
                print("💣 \(error.localizedDescription)\n🖥 \(urlString)")
            }
            completion(error: error, data: data)
        })
        task.resume()
    }
    
    // MARK: List
    
    func fetchMetars(location location: CLLocation, completion: ServiceCompletionBlock) {
        let query = NSString(format: "radialDistance=100;%f,%f", location.coordinate.longitude, location.coordinate.latitude) as String
        fetch(query: query, completion: completion)
    }
    
    func fetchMetars(station stationString: String, completion: ServiceCompletionBlock) {
        let query = NSString(format: "stationString=%@", stationString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!) as String
        fetch(query: query, completion: completion)
    }

    func fetchMetars(stations stationStrings: [String], completion: ServiceCompletionBlock) {
        let stations = stationStrings.map { $0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! }

        let query = NSString(format: "stationString=%@", stations.joinWithSeparator(",")) as String
        fetch(query: query, completion: completion)
    }
    
}