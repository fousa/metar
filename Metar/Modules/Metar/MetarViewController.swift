//
//  MetarViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 17/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

import Crashlytics

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

        // Log the view event.
        Answers.logContentViewWithName("Detail", contentType: "controller", contentId: metar.station.name, customAttributes: nil)
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

            // Log the view event.
            Answers.logContentViewWithName("Share", contentType: "action", contentId: self.airport!.stationName, customAttributes: nil)

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
        } else if let controller = segue.destinationViewController as? MapViewController {
            controller.metar = metar
        } else if let controller = segue.destinationViewController as? MetarDetailsViewController {
            controller.metar = metar
        }
    }
    
    // MARK: - Status bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: - Preview

    override func previewActionItems() -> [UIPreviewActionItem] {
        var actions = [UIPreviewAction]()
        if let _ = airport {
            actions.append(UIPreviewAction(title: NSLocalizedString("search_actions_label_remove", comment: ""), style: UIPreviewActionStyle.Destructive) { action, controller in
                print("💾 Remove metar \(self.airport!.stationName) from 3D action")

                MTRDataManager.sharedInstance.remove(airport: self.airport!)
                MTRShortcutManager.sharedInstance.reloadShortcuts()
            })
        } else {
            actions.append(UIPreviewAction(title: NSLocalizedString("search_actions_label_add", comment: ""), style: UIPreviewActionStyle.Default) { action, controller in
                print("💾 Save metar \(self.metar.station.name) from 3D action")

                MTRDataManager.sharedInstance.create(withMetar: self.metar)
                MTRShortcutManager.sharedInstance.reloadShortcuts()
            })
        }
        return actions
    }
    
}