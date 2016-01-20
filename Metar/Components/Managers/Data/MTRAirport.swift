//
//  MTRAirport.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 19/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import CoreData

@objc(MTRAirport)
class MTRAirport: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var country: String?
    @NSManaged var site: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var elevation: NSNumber?
    @NSManaged var rawMetarData: String?

}
