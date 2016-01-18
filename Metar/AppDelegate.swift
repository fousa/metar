//
//  AppDelegate.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

enum ShortcutType: String {
    case Search = "search"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - Application flow

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupAppearance()
        setupShortcutItems()

        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            handle(shortcutItem: shortcutItem, fromLaunch: true)
            return false
        }

        return true
    }

    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        handle(shortcutItem: shortcutItem)
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

    private func handle(shortcutItem shortcutItem: UIApplicationShortcutItem, fromLaunch: Bool = false) {
        print("🖕 Handle action \(shortcutItem.type)")

        let type = ShortcutType(rawValue: shortcutItem.type)
        if type == .Search {
            guard let controller = self.window!.rootViewController as? DashboardViewController else {
                return
            }

            if fromLaunch {
                controller.shortcutItem = shortcutItem
            } else {
                controller.addStation(shortcutItem)
            }
        }
    }

    private func setupShortcutItems() {
        let searchIcon = UIApplicationShortcutIcon(type: .Search)
        let searchItem = UIApplicationShortcutItem(type: ShortcutType.Search.rawValue, localizedTitle: "Search for metars", localizedSubtitle: nil, icon: searchIcon, userInfo: nil)
        UIApplication.sharedApplication().shortcutItems = [searchItem]
    }

}
