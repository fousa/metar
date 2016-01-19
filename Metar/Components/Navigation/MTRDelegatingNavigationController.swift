//
//  DelegatingNavigationController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 16/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class MTRDelegatingNavigationController: UINavigationController {

    // MARK: - Status bar

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle() ?? .LightContent
    }

}
