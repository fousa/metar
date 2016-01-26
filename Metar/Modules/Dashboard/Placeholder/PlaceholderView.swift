//
//  PlaceholderView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 16/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

protocol PlaceholderViewDelegate {
    func placeholderViewDidTapAdd(view: PlaceholderView)
}

class PlaceholderView: UIView {

    var delegate: PlaceholderViewDelegate?

    // MARK: - Privates

    private var imageRange: NSRange?
    
    // MARK: - Outlets
    
    @IBOutlet private var noAirportsLabel: UILabel!
    @IBOutlet private var pressLabel: UILabel!
    
    // MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        noAirportsLabel.text = NSLocalizedString("dashboard_label_no_data", comment: "")
        noAirportsLabel.boldify(substring: NSLocalizedString("dashboard_label_no_airports", comment: ""))
        
        pressLabel.text = NSLocalizedString("dashboard_label_add_one_text", comment: "")
        imageRange = pressLabel.replaceImage(UIImage(named: "Add")!, forPlaceholderText: "{add}")
        pressLabel.boldify(substring: NSLocalizedString("dashboard_label_add_one", comment: ""))

        pressLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapped:"))
        pressLabel.userInteractionEnabled = true
    }

    // MARK: - Gestures

    func tapped(gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else {
            return
        }

        let location = gesture.locationInView(label)
        let storage = NSTextStorage(attributedString: label.attributedText!)
        let layoutManager = NSLayoutManager()
        storage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: CGSizeMake(label.frame.size.width, label.frame.size.height + 100))
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let characterIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if let range = imageRange where characterIndex == range.location {
            delegate?.placeholderViewDidTapAdd(self)
        }
    }

}
