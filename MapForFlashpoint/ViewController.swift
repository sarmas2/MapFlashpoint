//
//  ViewController.swift
//  MapForFlashpoint
//
//  Created by User on 7/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    var currentCoordinate: CLLocationCoordinate2D?

    var locationArray = [
        ["title": "Chicago Park Theatre", "category": "Theatre", "latitude": 41.885134, "longitude": -87.627670],
        ["title": "Millenium Park Park", "category": "Park", "latitude": 41.882709, "longitude": -87.623826],
        ["title": "Harold Washington Library", "category": "Library", "latitude": 41.876314, "longitude": -87.627819],
        ["title": "Chicago Public Library", "category": "Library", "latitude": 41.876934, "longitude": -87.627732],
        ["title": "West Loop Branch Chicago Public School", "category": "Library", "latitude": 41.884153, "longitude": -87.654829],
        ["title": "National Museum of Mexican Art", "category": "Museum", "latitude": 41.855880, "longitude": -87.672839],
        ["title": "Shed Aquarium", "category": "Museum", "latitude": 41.866430, "longitude": -87.613443],
        ["title": "Fosco Park Community Center", "category": "Park", "latitude": 41.864980, "longitude": -87.656983]
    ]
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = MKMapType.mutedStandard
        mapView.delegate = self
        
        configureLocationServices()
    }

    func configureLocationServices(){
        
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse{
            
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    func beginLocationUpdates(locationManager: CLLocationManager){
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    
    func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    func createAnnotations(locations: [[String:Any]]){
        for location in locationArray {
            let annotations = MKPointAnnotation()
            annotations.title = location["title"] as? String
            annotations.subtitle = location["category"] as? String
            annotations.coordinate = CLLocationCoordinate2DMake(location["latitude"] as! CLLocationDegrees, location["longitude"] as! CLLocationDegrees)
    
            mapView.addAnnotation(annotations)
            
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        
        guard let latestLocation = locations.first else {return}
        
        if currentCoordinate == nil{
            zoomToLatestLocation(with: latestLocation.coordinate)
            createAnnotations(locations: locationArray)
        }
        
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The Status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: manager)
        }
    }
}

extension ViewController: MKMapViewDelegate{

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")



        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }

        if annotation.subtitle == "Park"{
            annotationView?.image = UIImage(named: "Park")
        } else if annotation.subtitle == "Library"{
            annotationView?.image = UIImage(named: "Library")
        } else if annotation.subtitle == "Museum"{
            annotationView?.image = UIImage(named: "Library")
        } else if annotation.subtitle == "Theatre"{
            annotationView?.image = UIImage(named: "School")
        } else if annotation === mapView.userLocation{
            annotationView?.image = UIImage(named: "Person")
        }

        annotationView?.canShowCallout = true

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("The annotation was selected: \(String(describing: view.annotation?.title))")
    }
}


