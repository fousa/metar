//
//  MetarViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 17/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class MetarViewController: UIViewController {
    
    var metarView: MetarView! { return self.view as! MetarView } // tailor:disable
    
    var metar: Metar!
    var airport: MTRAirport? {
        didSet {
            let metar = Metar(raw: airport?.rawMetarData ?? "")
            metar.station.name = airport?.name
            metar.station.site = airport?.site
            metar.station.country = airport?.country
            metar.station.elevation = airport?.elevation?.integerValue
            metar.station.location = airport?.location
            self.metar = MTRParser(metar: metar).parse()
        }
    }
    
    // MARK: - View flow
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        title = metar.station.name

        if let _ = airport {
            navigationController?.navigationBar.translucent = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss:")
        } else {
            navigationController?.navigationBar.topItem?.title = NSLocalizedString("detail_label_back", comment: "")
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "favoriteMetar:")
        }
    }
    
    // MARK: - Actions
    
    func favoriteMetar(sender: AnyObject) {
        print("💾 Favorite metar \(metar.station.name)")
        MTRDataManager.sharedInstance.create(withMetar: metar)
        MTRShortcutManager.sharedInstance.reloadShortcuts()
    }

    func dismiss(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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