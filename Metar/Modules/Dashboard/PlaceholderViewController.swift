//
//  PlaceholderViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

protocol PlaceholderViewControllerDelegate {
    func placeholderViewControllerWillAddStation(controller: PlaceholderViewController)
}

class PlaceholderViewController: UIViewController {
    
    var delegate: PlaceholderViewControllerDelegate?
    
    // MARK: - Actions
    
    @IBAction func addStation(sender: AnyObject) {
        delegate?.placeholderViewControllerWillAddStation(self)
    }

}
