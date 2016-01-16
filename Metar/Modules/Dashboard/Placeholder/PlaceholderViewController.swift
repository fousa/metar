//
//  PlaceholderViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

protocol PlaceholderViewControllerDelegate: class {
    func placeholderViewControllerWillAddStation(controller: PlaceholderViewController)
}

class PlaceholderViewController: UIViewController {
    var placeholderView: PlaceholderView! { return self.view as! PlaceholderView }
    
    weak var delegate: PlaceholderViewControllerDelegate?
    
    // MARK: - Actions
    
    @IBAction func addStation(sender: AnyObject) {
        delegate?.placeholderViewControllerWillAddStation(self)
    }
}