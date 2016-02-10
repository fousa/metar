//
//  MetarDataCollectionViewCell.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 10/02/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class MetarDataCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!

    // MARK: - Configure

    func configure(title title: String, value: String?) {
        titleLabel.text = title.uppercaseString
        valueLabel.text = value ?? "---"
    }

}