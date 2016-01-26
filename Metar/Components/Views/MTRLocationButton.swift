//
//  MTRLocationButton.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 26/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

import PureLayout
import JTMaterialSpinner

class MTRLocationButton: UIButton {

    private var locationImageView: UIImageView!
    private var locationSpinner: JTMaterialSpinner!
    private var locationLabel: UILabel!

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configureImage()
        configureSpinner()
        configureLabel()
    }

    // MARK: - Subview

    private func configureImage() {
        locationImageView = UIImageView(image: UIImage(named: "Location"))
        locationImageView.contentMode = .Center
        addSubview(locationImageView)
        locationImageView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Right)
    }

    private func configureSpinner() {
        locationSpinner = JTMaterialSpinner.newAutoLayoutView()
        locationSpinner.circleLayer.lineWidth = 1.0
        locationSpinner.circleLayer.strokeColor = UIColor.mtrRobinsEggColor().CGColor
        addSubview(locationSpinner)

        let padding = CGFloat(5.0)
        locationSpinner.autoPinEdge(.Top, toEdge: .Top, ofView: locationImageView, withOffset: padding)
        locationSpinner.autoPinEdge(.Right, toEdge: .Right, ofView: locationImageView, withOffset: -padding)
        locationSpinner.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: locationImageView, withOffset: -padding)
        locationSpinner.autoPinEdge(.Left, toEdge: .Left, ofView: locationImageView, withOffset: padding)
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

    // MARK: - Animation

    func startAnimating() {
        locationImageView.hidden = true
        userInteractionEnabled = false
        locationSpinner.beginRefreshing()
    }

    func stopAnimating() {
        locationImageView.hidden = false
        userInteractionEnabled = true
        locationSpinner.endRefreshing()
    }

}