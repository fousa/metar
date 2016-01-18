//
//  PlaceholderView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 16/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class PlaceholderView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet private var noAirportsLabel: UILabel!
    @IBOutlet private var pressLabel: UILabel!
    
    // MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        noAirportsLabel.text = NSLocalizedString("dashboard_label_no_data", comment: "")
        noAirportsLabel.boldify(substring: NSLocalizedString("dashboard_label_no_airports", comment: ""))
        
        pressLabel.text = NSLocalizedString("dashboard_label_add_one_text", comment: "")
        pressLabel.replaceImage(UIImage(named: "Add")!, forPlaceholderText: "{add}")
        pressLabel.boldify(substring: NSLocalizedString("dashboard_label_add_one", comment: ""))
    }
    
}