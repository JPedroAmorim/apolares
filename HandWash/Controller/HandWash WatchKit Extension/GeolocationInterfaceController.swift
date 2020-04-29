//
//  GeolocationInterfaceController.swift
//  HandWash WatchKit Extension
//
//  Created by Rodrigo Takumi on 24/04/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import WatchKit
import Foundation
import MapKit
import CoreLocation
import UIKit

class GeolocationInterfaceController: WKInterfaceController {

    @IBOutlet weak var mapView: WKInterfaceMap!
    
    var locationManager = CLLocationManager()
    let regionInMeters: Double = 100
    
    // MARK: Life Cycle
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Setup locationManager.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func willActivate() {
        super.willActivate()
    
        
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
    // Get and show the user`s current location in map.
    func centerViewOnUserLocation() {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: userLocation,
                                                 latitudinalMeters: self.regionInMeters,
                                                 longitudinalMeters: self.regionInMeters)
            
            self.mapView.setRegion(region)
            
            
        }
    }
    
    // Save home location
    @IBAction func saveCurrentLocation() {
        print(self.locationManager.location?.coordinate.latitude as Any)
        print(self.locationManager.location?.coordinate.longitude as Any)
        
        self.mapView.setShowsUserLocation(false)
        
        if let location = locationManager.location?.coordinate {
            self.mapView.addAnnotation(location, withImageNamed: "home01", centerOffset: CGPoint())
        }
    }
}

extension GeolocationInterfaceController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .authorizedWhenInUse:
                    self.mapView.setShowsUserLocation(true)
                    centerViewOnUserLocation()
                    self.locationManager.startUpdatingLocation()
                    break
                case .denied:
                    // Negado, desabilitado globalmente ou device em modo aviao. O que fazer?
                    break
                case .notDetermined:
                    self.locationManager.requestWhenInUseAuthorization()
                case .restricted:
                    break
                case .authorizedAlways:
                    break
            @unknown default:
                fatalError()
            }
        } else {
            print("Location services are not enabled")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
