//
//  MTRDefaults.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 27/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import Foundation

class MTRDefaults: NSUserDefaults {

    // This user default value is used to indicate the last refresh date.
    private static let MTRDefaultsUpdateAtKey = "MTRDefaultsUpdateAtKey"

    // MARK: - Overrides

    static var updatedAt: NSDate? {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.synchronize()
            return defaults.objectForKey(MTRDefaultsUpdateAtKey) as? NSDate
        }
        set {
            print("💾 Write updated at \(newValue) to defaults")
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newValue, forKey: MTRDefaultsUpdateAtKey)
            defaults.synchronize()
        }
    }
}