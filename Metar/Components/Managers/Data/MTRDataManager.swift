//
//  MTRDataManager.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 19/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import Foundation
import AERecord
import CoreData

class MTRDataManager {

    static let sharedInstance = MTRDataManager()

    // MARK: - Init

    private init() {
        let containerPath = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.fousa.metar")
        let storeURL = containerPath?.URLByAppendingPathComponent("Metar.sqlite")
        do {
            try AERecord.loadCoreDataStack(storeURL: storeURL!)
        } catch _ {
            print("💣 Initializing data store failed.")
        }
    }

    // MARK: - Create

    func create(withMetar metar: Metar, context: NSManagedObjectContext = AERecord.defaultContext) {

    }

    // MARK: - Remove

    func remove(metar metar: Metar, context: NSManagedObjectContext = AERecord.defaultContext) {
        if let airport = airport(forMetar: metar, context: context) {
            remove(airport: airport, context: context)
        }
    }

    func remove(airport airport: MTRAirport, context: NSManagedObjectContext = AERecord.defaultContext) {
        airport.deleteFromContext(context)
        AERecord.saveContextAndWait(context)
    }

    // MARK: - Checks

    func exists(metar metar: Metar, context: NSManagedObjectContext = AERecord.defaultContext) -> Bool {
        return true
    }

    func airport(forMetar metar: Metar, context: NSManagedObjectContext = AERecord.defaultContext) -> MTRAirport? {
        guard let name = metar.station.name else {
            // When name can not be found.
            return nil
        }

        return MTRAirport.firstWithAttribute("name", value: name, context: context) as? MTRAirport
    }

}