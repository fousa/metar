//
//  SearchMetarTableViewCell.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class SearchMetarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stationNameLabel: UILabel!
    
    func configure(withMetar metar: Metar) {
        stationNameLabel.text = metar.station.name
    }
}
