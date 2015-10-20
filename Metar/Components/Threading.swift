//
//  Threading.swift
//  METAR
//
//  Created by Jelle Vandenbeeck on 12/05/15.
//  Copyright (c) 2015 Jelle Vandenbeeck. All rights reserved.
//

import Foundation

func dispatch_main_after(interval: NSTimeInterval, block: dispatch_block_t!) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), block)
}

func dispatch_async_main(block: dispatch_block_t!) {
    dispatch_async(dispatch_get_main_queue(), block)
}