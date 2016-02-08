//
//  MetarView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 17/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

import AnimatedSegmentSwitch
import Crashlytics

class MetarView: UIView {

    @IBOutlet private var segmentedSwitch: AnimatedSegmentSwitch!
    @IBOutlet private var leadingMapConstraint: NSLayoutConstraint!

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

        let presentMap = segmentedSwitch.selectedIndex == 1
        leadingMapConstraint.priority = presentMap ? 800.0 : 600.0
        // Use all the segmented variables in order to obtain the same animation result.
        UIView.animateWithDuration(segmentedSwitch.animationDuration, delay: 0.0, usingSpringWithDamping: segmentedSwitch.animationSpringDamping, initialSpringVelocity: segmentedSwitch.animationInitialSpringVelocity, options: [], animations: { finished in
            self.layoutIfNeeded()
        }, completion: nil)

        // Log the view event.
        Answers.logContentViewWithName("Detail", contentType: "view", contentId: presentMap ? "map" : "metar", customAttributes: nil)
    }

}