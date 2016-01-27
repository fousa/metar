//
//  MTRAttributedLabel.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 27/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class MTRAttributedLabel: UILabel {

    // MARK: - Privates

    private var imageRange: NSRange?
    private var block: (() -> ())?

    // MARK: - Bold

    func boldify(substring substring: String) {
        if let attributedText = attributedText as? NSMutableAttributedString {
            // Lookup the range of the given substring.
            let range = (attributedText.string as NSString).rangeOfString(substring)
            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 18)!, range: range)
        }
    }

    func replaceImage(image: UIImage, forPlaceholderText placeholder: String, block: (() -> ())? = nil) {
        if let attributedText = attributedText as? NSMutableAttributedString {
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRectMake(0.0, -6.0, image.size.width, image.size.height)
            let imageAttachedString = NSAttributedString(attachment: attachment)

            // Lookup the range for the placeholder text, and place the image at
            // the found range. Persist the range for later use.
            imageRange = (attributedText.string as NSString).rangeOfString("{add}")
            attributedText.replaceCharactersInRange(imageRange!, withAttributedString: imageAttachedString)

            // Keep the completen block for when the user taps the image.
            self.block = block

            // Add a tap gesture to the label and
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapped:"))
            userInteractionEnabled = true
        }
    }

    // MARK: - Gestures

    func tapped(gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else {
            return
        }

        // Create the layout manager to handle the different characters that are
        // displayed in the label.
        let storage = NSTextStorage(attributedString: label.attributedText!)
        let layoutManager = NSLayoutManager()
        storage.addLayoutManager(layoutManager)

        // The text container defines the region that layouts the text. We need this in orde
        // to find the character for a given point.
        let textContainer = NSTextContainer(size: CGSizeMake(label.frame.size.width, label.frame.size.height + 100))
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        // Lookup the tapped character and execute the block.
        let location = gesture.locationInView(label)
        let characterIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if let range = imageRange where characterIndex == range.location {
            block?()
        }
    }
}