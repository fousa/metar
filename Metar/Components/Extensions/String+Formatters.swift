//
//  String+Formatters.swift
//  METAR
//
//  Created by Jelle Vandenbeeck on 12/05/15.
//  Copyright (c) 2015 Jelle Vandenbeeck. All rights reserved.
//

import Foundation

extension String {
    func formatDate() -> NSDate? {
        guard self.characters.count == 7 else {
            return nil
        }
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.componentsInTimeZone(NSTimeZone(abbreviation: "UTC")!, fromDate: NSDate())
        
        components.day = substring(0, length: 2)?.integerValue ?? 0
        components.hour = substring(2, length: 2)?.integerValue ?? 0
        components.minute = substring(4, length: 2)?.integerValue ?? 0
        components.second = 0
        return calendar.dateFromComponents(components)
    }
    
    func substring(location: Int, length: Int) -> NSString? {
        return (self as NSString).substringWithRange(NSRange(location: location, length: length))
    }
    
    func trim() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}