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
    var locationManager: CLLocationManager = CLLocationManager()
    var mapLocation: CLLocationCoordinate2D?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestLocation()
        
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
//        self.mapView.setShowsUserLocation(true)
//
//        self.mapLocation = CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945)
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region = MKCoordinateRegion(center: self.mapLocation!, span: span)
//        self.mapView.setRegion(region)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let currentLocation = locations[0]
//        let lat = currentLocation.coordinate.latitude
//        let long = currentLocation.coordinate.longitude
//
//        self.mapLocation = CLLocationCoordinate2DMake(lat, long)
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region = MKCoordinateRegion(center: self.mapLocation!, span: span)
//
//        self.mapView.setRegion(region)
//        self.mapView.addAnnotation(self.mapLocation!, with: .red)
    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.requestLocation()
//        }
//    }
//
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print(error.localizedDescription)
    }
    
    @IBAction func saveCurrentLocation() {
        print(self.mapLocation?.latitude as Any)
        print(self.mapLocation?.longitude as Any)
    }
}
