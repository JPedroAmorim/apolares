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
import UserNotifications
import UIKit
import Intents

class GeolocationInterfaceController: WKInterfaceController {

    @IBOutlet weak var mapView: WKInterfaceMap!
    
    var locationManager = CLLocationManager()
    let regionInMeters: Double = 5
    
    // MARK: Life Cycle
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Setup locationManager.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func setActivity(region: CLCircularRegion) {
        
        let userActivity = NSUserActivity(activityType: "Start_Wash_When_Home")
        userActivity.title = "Wash your hands"
        userActivity.isEligibleForPrediction = true
        userActivity.suggestedInvocationPhrase = "Yellow"
        userActivity.becomeCurrent()
        self.update(userActivity)
        
        let shortcut = INShortcut(userActivity: userActivity)
        let relevantShortcut = INRelevantShortcut(shortcut: shortcut)
        
        let cardTemplate = INDefaultCardTemplate(title: "Wash your hands")
        cardTemplate.subtitle = "When Arriving home, you should wash your hands"
        
        relevantShortcut.watchTemplate = cardTemplate
        
        let relevanceProvider = INLocationRelevanceProvider(region: region)
        
        relevantShortcut.relevanceProviders = [relevanceProvider]
        
        INRelevantShortcutStore.default.setRelevantShortcuts([relevantShortcut]) { error in
            if let error = error { /* */
                print(error.localizedDescription)
            }
            
            print("Region added!")
        }
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
            
            let circularRegion = CLCircularRegion(center: userLocation, radius: 1, identifier: "Home")
            self.setActivity(region: circularRegion)
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
    
//    func createNotification(NCenter: UNUserNotificationCenter) {
//        let center = CLLocationCoordinate2D(latitude: 37.335400, longitude: -122.009201)
//        let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "Headquarters")
//        region.notifyOnEntry = true
//        region.notifyOnExit = false
//       // let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
//        // let testTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let content = UNMutableNotificationContent()
//        content.categoryIdentifier = "myNotification"
//        content.title = "HandWash"
//        content.body = "Wash hands plz"
//        content.sound = UNNotificationSound.default
//        let request = UNNotificationRequest(identifier: "Test notification",
//                                            content: content,
//                                            trigger: trigger)
//        NCenter.add(request, withCompletionHandler: { (error) in
//            if error != nil {
//                print(error ?? "nao sei")
//            }
//            else {
//                print("notification scheduled")
//                Schedule.shared.setNotification(notification: request,
//                                                NCenter: NCenter)
//
//                self.popToRootController()
//            }
//
//        })
//    }
}

extension GeolocationInterfaceController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .authorizedWhenInUse:
                    self.mapView.setShowsUserLocation(true)
                    self.locationManager.startUpdatingLocation()
                    centerViewOnUserLocation()
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
