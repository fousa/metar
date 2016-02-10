//
//  MetarDetailsViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 08/02/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class MetarDetailsViewController: UIViewController {

    private let cellPadding: CGFloat = 10.0

    @IBOutlet var collectionView: UICollectionView!

    var metar: Metar!

    func formatWindDirection() -> String? {
        guard let direction = metar.wind?.direction else { return nil }
        return "\(direction)°"
    }

    func formatWindSpeed() -> String? {
        guard let speed = metar.wind?.speed, let unit = metar.wind?.unit else { return nil }
        return "\(speed) \(unit.format())"
    }

    func formatGustSpeed() -> String? {
        guard let speed = metar.wind?.gustSpeed, let unit = metar.wind?.unit else { return nil }
        return "\(speed) \(unit.format())"
    }

    func formatVarying() -> String? {
        guard let varying = metar.wind?.varying, let minimumDirection = metar.wind?.minimumDirection, let maximumDirection = metar.wind?.maximumDirection where varying else { return nil }
        return "\(minimumDirection)° - \(maximumDirection)°"
    }

    func formatVisibility() -> String? {
        guard let visibility = metar.visibility?.value, let unit = metar.visibility?.unit else { return nil }
        return "\(visibility) \(unit.format())"
    }

    func formatPressure() -> String? {
        guard let pressure = metar.pressure?.value, let unit = metar.pressure?.unit else { return nil }
        return "\(pressure) \(unit.format())"
    }

    private lazy var data: [(title: String, value: String?)] = {
        [unowned self] in

        return [
            (title: "WIND DIRECTION",        value: self.formatWindDirection()),
            (title: "ATMOSPHERIC PRESSURE",  value: self.formatPressure()),
            (title: "WIND SPEED",            value: self.formatWindSpeed()),
            (title: "HORIZONTAL VISIBILITY", value: self.formatVisibility()),
            (title: "WIND GUSTS",            value: self.formatGustSpeed()),
            (title: "FEW",                   value: nil),
            (title: "VARYING",               value: self.formatVarying()),
            (title: "OVERCAST",              value: nil),
        ]
    }()

    // MARK: - View flow

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.reloadData()
    }

}

extension MetarDetailsViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MetarDataCollectionViewCell

        let item = data[indexPath.item]
        cell.configure(title: item.title, value: item.value)

        return cell
    }

}

extension MetarDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize = (collectionView.bounds.size.width - (cellPadding * 2.0)) / 2.0
        return CGSizeMake(screenSize, 40.0)
    }

}