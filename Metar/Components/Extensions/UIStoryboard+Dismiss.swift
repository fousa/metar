//
//  UIStoryboard+Dismiss.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit

protocol UIStoryboardDelegate: AnyObject {
    func storyboardShouldDismiss(storyboard: UIStoryboard)
}

private var UIStoryboardDelegateKey = "delegate"

extension UIStoryboard {
    var delegate: UIStoryboardDelegate? {
        get {
            return objc_getAssociatedObject(self, &UIStoryboardDelegateKey) as? UIStoryboardDelegate
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIStoryboardDelegateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func dismiss() {
        delegate?.storyboardShouldDismiss(self)
    }
}