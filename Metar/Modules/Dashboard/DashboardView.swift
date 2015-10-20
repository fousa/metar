//
//  DashboardView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class DashboardView: UIView {
    
    @IBOutlet private var planeImageView: UIImageView!
    @IBOutlet private var planeTopConstraint: NSLayoutConstraint!
    @IBOutlet private var planeHorizontalConstraint: NSLayoutConstraint!
    
    func startIntroAnimation(completion: () -> ()) {
        planeTopConstraint.priority = 900
        planeHorizontalConstraint.priority = 900
        UIView.animateWithDuration(0.8, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .CurveEaseInOut, animations: { () -> Void in
            self.layoutIfNeeded()
        }, completion: { finished in
            completion()
        })
    }
    
    func rotatePlane(toAngle angle: CGFloat) {
        UIView.animateWithDuration(0.35) {
            self.planeImageView.transform = CGAffineTransformMakeRotation(angle)
        }
    }
}
