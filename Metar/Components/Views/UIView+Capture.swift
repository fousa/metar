//
//  UIView+Capture.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 26/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

extension UIView {

    func snapshot() -> UIImage {
        let captureBounds = bounds
        UIGraphicsBeginImageContextWithOptions(captureBounds.size, true, 0.0)
        drawViewHierarchyInRect(captureBounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

}