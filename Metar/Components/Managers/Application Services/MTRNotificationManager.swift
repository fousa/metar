//
//  MTRNotificationManager.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 19/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import Foundation

class MTRNotificationManager {

    private var observers = [AnyObject]()

    // MARK: - Init

    deinit {
        for observer in observers {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        observers = []
    }

    // MARK: - Register

    func observeNotification(withName name: String, block: (NSNotification! -> Void)) {
        let observer = NSNotificationCenter.defaultCenter().addObserverForName(name, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: block)
        observers.append(observer)
    }
    
}