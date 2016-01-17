//
//  MetarViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 17/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class MetarViewController : UIViewController {
    
    var metarView: MetarView! { return self.view as! MetarView }
    
    var metar: Metar!
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = metar.station.name
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("detail_label_back", comment: "")
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? MetarStationDetailViewController {
            controller.metar = metar
        }
    }
    
    // MARK: - Status bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}