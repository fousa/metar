//
//  MTRSpinnerBarButtonItem.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 17/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit
import JTMaterialSpinner

class MTRSpinnerBarButtonItem : UIBarButtonItem {
    
    private var spinner: JTMaterialSpinner!
    
    // MARK: - Init
    
    convenience init(color: UIColor) {
        let spinner = JTMaterialSpinner(frame: CGRectMake(0.0, 0.0, 20.0, 20.0))
        self.init(customView: spinner)
        
        // Add loading bar button view.
        spinner.circleLayer.lineWidth = 1.0
        spinner.circleLayer.strokeColor = color.CGColor
        self.spinner = spinner
    }
    
    // MARK: - Animation
    
    func startAnimating() {
        spinner.beginRefreshing()
    }
    
    func stopAnimating() {
        spinner.endRefreshing()
    }
}