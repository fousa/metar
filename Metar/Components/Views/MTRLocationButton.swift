//
//  MTRLocationButton.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 26/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

import PureLayout

class MTRLocationButton: UIButton {

    private var locationImageView: UIImageView!
    private var locationLabel: UILabel!

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configureImage()
        configureLabel()
    }

    // MARK: - Subview

    private func configureImage() {
        locationImageView = UIImageView(image: UIImage(named: "Location"))
        locationImageView.contentMode = .Center
        addSubview(locationImageView)
        locationImageView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Right)
    }

    private func configureLabel() {
        locationLabel = UILabel()
        locationLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightLight)
        locationLabel.text = NSLocalizedString("search_label_current_location", comment: "")
        locationLabel.textColor = UIColor.mtrRobinsEggColor()
        addSubview(locationLabel)
        locationLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Left)
        locationLabel.autoPinEdge(.Left, toEdge: .Right, ofView: locationImageView, withOffset: 16.0)
    }

}