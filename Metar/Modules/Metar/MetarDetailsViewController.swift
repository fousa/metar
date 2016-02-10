//
//  MetarDetailsViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 08/02/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class MetarDetailsViewController: UIViewController {

    private let cellPadding: CGFloat = 18.0

    @IBOutlet var collectionView: UICollectionView!

    var metar: Metar!

    // MARK: - View flow

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.reloadData()
    }

}

extension MetarDetailsViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        return cell
    }

}

extension MetarDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize = (collectionView.bounds.size.width - (cellPadding * 2.0)) / 2.0
        return CGSizeMake(screenSize, 40.0)
    }

}