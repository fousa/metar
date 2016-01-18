//
//  UILabel+Attributes.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 16/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

extension UILabel {

    func boldify(substring substring: String) {
        if let attributedText = attributedText as? NSMutableAttributedString {
            let range = (attributedText.string as NSString).rangeOfString(substring)
            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 18)!, range: range)
        }
    }

    func replaceImage(image: UIImage, forPlaceholderText placeholder: String) {
        if let attributedText = attributedText as? NSMutableAttributedString {
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRectMake(0.0, -6.0, image.size.width, image.size.height)
            let imageAttachedString = NSAttributedString(attachment: attachment)
            let range = (attributedText.string as NSString).rangeOfString("{add}")
            attributedText.replaceCharactersInRange(range, withAttributedString: imageAttachedString)
        }
    }

}
