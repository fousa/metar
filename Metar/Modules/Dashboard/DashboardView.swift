//
//  DashboardView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

protocol DashboardViewDataSource: class {
    func numberOfStationsInDashboardView(dashboardView: DashboardView) -> Int
}

class DashboardView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var planeImageView: UIImageView!
    @IBOutlet private var tableContainerView: UIView!
    @IBOutlet private var placeholderContainerView: UIView!
    @IBOutlet private var addButton: UIButton!
    
    @IBOutlet private var planeWidthConstraints: NSLayoutConstraint!
    @IBOutlet private var planeHeightConstraints: NSLayoutConstraint!
    @IBOutlet private var planeTopConstraint: NSLayoutConstraint!
    @IBOutlet private var planeHorizontalConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    weak var dataSource: DashboardViewDataSource?

    private var animationFinished = false
    
    // MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableContainerView.alpha = 0.0
        placeholderContainerView.alpha = 0.0
        addButton.alpha = 0.0
    }
    
    // MARK: - Animation
    
    func startIntroAnimation(completion: () -> ()) {
        planeTopConstraint.priority = 900
        planeHorizontalConstraint.priority = 900
        planeWidthConstraints.priority = 900
        planeHeightConstraints.priority = 900
        UIView.animateWithDuration(0.8, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .CurveEaseInOut, animations: { () -> Void in
            self.tableContainerView.alpha = self.numberOfStations() > 0 ? 1.0 : 0.0
            self.placeholderContainerView.alpha = self.tableContainerView.alpha == 1.0 ? 0.0 : 1.0
            self.addButton.alpha = 1.0
            self.logoImageView.alpha = 0.0
            self.layoutIfNeeded()
        }, completion: { finished in
            self.animationFinished = true
            completion()
        })
    }
    
    func rotatePlane(toAngle angle: CGFloat) {
        UIView.animateWithDuration(0.35) {
            self.planeImageView.transform = CGAffineTransformMakeRotation(angle)
        }
    }

    // MARK: - Views

    func reloadContainerViewsIfNeeded() {
        // Only make the containers visible when the animation is finished.
        guard animationFinished else  {
            return
        }

        self.tableContainerView.alpha = self.numberOfStations() > 0 ? 1.0 : 0.0
        self.placeholderContainerView.alpha = self.tableContainerView.alpha == 1.0 ? 0.0 : 1.0
    }

    // MARK: - Data Source
    
    func numberOfStations() -> Int {
        return dataSource?.numberOfStationsInDashboardView(self) ?? 0
    }
    
}
