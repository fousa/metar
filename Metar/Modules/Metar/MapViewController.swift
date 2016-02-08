//
//  MapViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 08/02/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet private var mapView: MKMapView!

    var metar: Metar!

    // MARK: - View flow

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setRegion(MKCoordinateRegionMake(metar.station.location!.coordinate, MKCoordinateSpanMake(0.4, 0.4)), animated: false)
    }

}