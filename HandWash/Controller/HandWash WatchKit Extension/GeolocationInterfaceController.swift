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

class GeolocationInterfaceController: WKInterfaceController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: WKInterfaceMap!
    
    var locationManager = CLLocationManager()
//    var mapLocation: CLLocationCoordinate2D?
    let regionInMeters: Double = 100
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func willActivate() {
        super.willActivate()
        
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                self.mapView.setShowsUserLocation(true)
                centerViewOnUserLocation()
                self.locationManager.startUpdatingLocation()
                break
            case .denied:
                break
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .restricted:
                break
            case .authorizedAlways:
                break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print(error.localizedDescription)
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: self.regionInMeters,
                                                 longitudinalMeters: self.regionInMeters)
            
//            self.mapLocation = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            self.mapView.setRegion(region)
        }
        else {
            
        }
    }
    
    @IBAction func saveCurrentLocation() {
        print(self.locationManager.location?.coordinate.latitude)
        print(self.locationManager.location?.coordinate.longitude)
    }
}
