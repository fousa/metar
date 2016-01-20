//
//  MTRShortcutManager.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

enum MTRShortcutType: String {
    case Search = "search"
    case Airport = "airport"
}

class MTRShortcutManager: NSObject {

    static let sharedInstance = MTRShortcutManager()

    private let shortcutManagerNameKey = "shortcutManagerNameKey"

    // MARK: - Data

    func reloadShortcuts() {
        var items = [searchShortcutItem()]
        for airport in MTRDataManager.sharedInstance.airports().prefix(3) {
            items.append(airportShortcutItem(forAirport: airport))
        }

        UIApplication.sharedApplication().shortcutItems = items
    }

    // MARK: - Handling

    func handle(shortcutItem shortcutItem: UIApplicationShortcutItem, onRootViewController rootViewController: UIViewController?, fromLaunch: Bool = false) {
        print("🖕 Handle action \(shortcutItem.type)")

        let type = MTRShortcutType(rawValue: shortcutItem.type)
        if type == .Search {
            guard let controller = rootViewController as? DashboardViewController else {
                return
            }

            if fromLaunch {
                controller.shortcutItem = shortcutItem
            } else {
                controller.addStation(shortcutItem)
            }
        }
    }

    // MARK: - Types

    private func searchShortcutItem() -> UIApplicationShortcutItem {
        let searchIcon = UIApplicationShortcutIcon(type: .Search)
        return UIApplicationShortcutItem(type: MTRShortcutType.Search.rawValue, localizedTitle: "Search for metars", localizedSubtitle: nil, icon: searchIcon, userInfo: nil)
    }

    private func airportShortcutItem(forAirport airport: MTRAirport) -> UIApplicationShortcutItem {
        let airportIcon = UIApplicationShortcutIcon(type: .Location)
        return UIApplicationShortcutItem(type: MTRShortcutType.Airport.rawValue, localizedTitle: airport.name, localizedSubtitle: nil, icon: airportIcon, userInfo: [shortcutManagerNameKey: airport.name])
    }

}