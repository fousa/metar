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
            if let airport = self.airport {
                let metar = Metar(raw: airport.rawMetarData ?? "")
                metar.station.name = airport.name
                metar.station.site = airport.site
                metar.station.country = airport.country
                metar.station.elevation = airport.elevation?.integerValue
                metar.station.location = airport.location
                self.metar = MTRParser(metar: metar).parse()
            }
        }
    }
    
    // MARK: - View flow

    override func viewDidLoad() {
        super.viewDidLoad()

        if airport == nil {
            airport = MTRDataManager.sharedInstance.airport(forMetar: metar)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        title = metar.station.name
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("detail_label_back", comment: "")

        reloadBarButtonItems()
    }

    // MARK: - Bar buttons

    private func reloadBarButtonItems() {
        if let _ = airport {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "actions:")
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save:")
        }
    }
    
    // MARK: - Actions

    func actions(actions: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("detail_actions_label_remove", comment: ""), style: .Destructive) { action in
            print("💾 Remove metar \(self.airport!.stationName)")
            MTRDataManager.sharedInstance.remove(airport: self.airport!)
            self.airport = nil
            self.reloadBarButtonItems()

            MTRShortcutManager.sharedInstance.reloadShortcuts()
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("detail_actions_label_share", comment: ""), style: .Default) { action in
            print("💾 Share metar \(self.airport!.stationName)")

            let items = [
                self.airport!.stationName!,
                self.airport!.rawMetarData!,
                self.view.snapshot()]
            let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("detail_actions_label_cancel", comment: ""), style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func save(sender: AnyObject) {
        print("💾 Save metar \(metar.station.name)")

        airport = MTRDataManager.sharedInstance.create(withMetar: metar)
        reloadBarButtonItems()

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