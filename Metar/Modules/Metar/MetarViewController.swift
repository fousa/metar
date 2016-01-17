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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("detail_label_back", comment: "")
        title = metar.station.name
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "favoriteMetar:")
    }
    
    // MARK: - Actions
    
    func favoriteMetar(sender: AnyObject) {
        print("💾 Favorite metar \(metar.station.name)")
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