//
//  DashboardViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    var dashboardView: DashboardView! { return self.view as! DashboardView }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dashboardView.startIntroAnimation()
    }
}
