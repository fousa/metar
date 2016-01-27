//
//  PlaceholderView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 16/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

protocol PlaceholderViewDelegate {
    func placeholderViewDidTapAdd(view: PlaceholderView)
}

class PlaceholderView: UIView {

    var delegate: PlaceholderViewDelegate?

    // MARK: - Privates

    private var imageRange: NSRange?
    
    // MARK: - Outlets
    
    @IBOutlet private var noAirportsLabel: MTRAttributedLabel!
    @IBOutlet private var pressLabel: MTRAttributedLabel!
    
    // MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()

        noAirportsLabel.text = NSLocalizedString("dashboard_label_no_data", comment: "")
        noAirportsLabel.boldify(substring: NSLocalizedString("dashboard_label_no_airports", comment: ""))

        pressLabel.text = NSLocalizedString("dashboard_label_add_one_text", comment: "")
        pressLabel.replaceImage(UIImage(named: "Add")!, forPlaceholderText: "{add}") {
            self.delegate?.placeholderViewDidTapAdd(self)
        }
        pressLabel.boldify(substring: NSLocalizedString("dashboard_label_add_one", comment: ""))
    }

}
