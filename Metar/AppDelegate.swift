//
//  AppDelegate.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - Application flow

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupFabric()
        setupData()
        setupAppearance()
        setupShortcutItems()

        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            MTRShortcutManager.sharedInstance.handle(shortcutItem: shortcutItem, onRootViewController: self.window?.rootViewController, fromLaunch: true)
            return false
        }

        return true
    }

    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        MTRShortcutManager.sharedInstance.handle(shortcutItem: shortcutItem, onRootViewController: self.window?.rootViewController)
    }

    // MARK: - Fabric

    private func setupFabric() {
        Fabric.with([Crashlytics.self])
    }

    // MARK: - Data

    private func setupData() {
        MTRDataManager.sharedInstance
    }

    // MARK: - Layout

    private func setupAppearance() {
        // Setup navigation bar appearance.
        UINavigationBar.appearance().tintColor = UIColor(red: 0.33, green: 0.85, blue: 0.98, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor(red: 0, green: 0.12, blue: 0.2, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(18)
        ]

        // Setup search bar appearance.
        UISearchBar.appearance().barTintColor = UIColor(red: 0, green: 0.12, blue: 0.2, alpha: 1)
    }

    // MARK: - Shortcut

    private func setupShortcutItems() {
        MTRShortcutManager.sharedInstance.reloadShortcuts()
    }

}
