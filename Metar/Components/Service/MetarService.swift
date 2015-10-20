//
//  MetarService.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import Foundation

class MetarService: NSObject {
    
    // MARK: - Properties
    
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
    
    private func fetch(query query: String, completion: (error: NSError?, data: NSData?) -> ()) {
        let URLString = NSString(format: "%@%@", BaseURLString, query)
        let URL = NSURL(string: URLString as String)
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "GET"
        
        session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let task = session!.dataTaskWithRequest(request, completionHandler: { (data : NSData?, response : NSURLResponse?, error : NSError?)-> Void in
            if let error = error {
                print("💣 \(error.localizedDescription)\n🖥 \(URLString)")
            }
            completion(error: error, data: data)
        })
        task.resume()
    }
    
}