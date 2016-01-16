//
//  AppDelegate.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupAppearance()
        return true
    }
    
    // MARK: - Layout
    
    private func setupAppearance() {
        // Setup navigation bar appearance.
        UINavigationBar.appearance().tintColor = UIColor(red:0.33, green:0.85, blue:0.98, alpha:1)
        UINavigationBar.appearance().barTintColor = UIColor(red:0, green:0.12, blue:0.2, alpha:1)
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(18)
        ]
        
        // Setup search bar appearance.
        UISearchBar.appearance().barTintColor = UIColor(red:0, green:0.12, blue:0.2, alpha:1)
    }
}