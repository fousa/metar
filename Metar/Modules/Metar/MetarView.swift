//
//  MetarView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 17/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

import AnimatedSegmentSwitch

class MetarView: UIView {

    @IBOutlet private var segmentedSwitch: AnimatedSegmentSwitch!

    // MARK: - View flow

    override func awakeFromNib() {
        super.awakeFromNib()

        segmentedSwitch.cornerRadius = 5.0
        segmentedSwitch.thumbCornerRadius = 5.0
        segmentedSwitch.backgroundColor = UIColor.clearColor()
        segmentedSwitch.font = UIFont.systemFontOfSize(13.0, weight: UIFontWeightRegular)
        segmentedSwitch.titleColor = UIColor.mtrGreyColor()
        segmentedSwitch.selectedTitleColor = UIColor.mtrDarkBlueColor()
        segmentedSwitch.thumbColor = UIColor.mtrBlueColor()
        segmentedSwitch.items = [
            NSLocalizedString("detail_segment_label_metar", comment: ""),
            NSLocalizedString("detail_segment_label_map", comment: "")
        ]


    }

    // MARK: - Action

    @IBAction func switchedSegment(sender: AnyObject) {
        print("🎯 Switch to segment \(segmentedSwitch.selectedIndex)")
    }

}