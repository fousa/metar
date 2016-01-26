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
    var placeholderView: PlaceholderView! { return self.view as! PlaceholderView } // tailor:disable
    
    weak var delegate: PlaceholderViewControllerDelegate?

    // MARK: - View flow

    override func viewDidLoad() {
        super.viewDidLoad()

        placeholderView.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func addStation(sender: AnyObject) {
        delegate?.placeholderViewControllerWillAddStation(self)
    }
    
}

extension PlaceholderViewController: PlaceholderViewDelegate {

    func placeholderViewDidTapAdd(view: PlaceholderView) {
        delegate?.placeholderViewControllerWillAddStation(self)
    }

}