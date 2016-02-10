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

    private lazy var data: [(title: String, value: String?)] = {
        [unowned self] in

        return [
            (title: NSLocalizedString("metar_data_wind_direction", comment: ""), value: self.metar.formatWindDirection()),
            (title: NSLocalizedString("metar_data_pressure", comment: ""), value: self.metar.formatPressure()),
            (title: NSLocalizedString("metar_data_wind_speed", comment: ""), value: self.metar.formatWindSpeed()),
            (title: NSLocalizedString("metar_data_visibility_horizontal", comment: ""), value: self.metar.formatVisibility()),
            (title: NSLocalizedString("metar_data_wind_gusts", comment: ""), value: self.metar.formatGustSpeed()),
            (title: "FEW", value: nil),
            (title: NSLocalizedString("metar_data_wind_varying", comment: ""), value: self.metar.formatVarying()),
            (title: "OVERCAST", value: nil),
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