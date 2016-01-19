//
//  Station.swift
//  METAR
//
//  Created by Jelle Vandenbeeck on 12/05/15.
//  Copyright (c) 2015 Jelle Vandenbeeck. All rights reserved.
//

import Foundation
import CoreLocation

class Station {
    
    // MARK: - Properties
    
    var name: String?
    var site: String?
    var country: String?
    var location: CLLocation?
    var elevation: Int?
    
    // MARK: - Init
    
    init() {}
    
}
