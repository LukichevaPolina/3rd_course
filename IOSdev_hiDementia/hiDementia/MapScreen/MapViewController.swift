//
//  MapViewController.swift
//  hiDementia
//
//  Created by Сапожников Андрей Михайлович on 22.12.2021.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

protocol MapsViewControllerDelegate : AnyObject {
    
    func mapsViewControllerDidSelectAnnotation(mapItem :MKMapItem)
}

class PlaceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var title: String? = "Title"
}

class MapViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var myMapView: MKMapView!
    weak var delegate :MapsViewControllerDelegate!
    var locationManager :CLLocationManager!
    let place :String = "pharmacy or drugstore"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView = {
            var view = MKMapView()
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            return view
        } ()
        view.addSubview(myMapView)
        myMapView?.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("IM IN UPDATE")
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location : CLLocation) {
        print("IM IN RENDER")
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        print(coordinate)
        self.myMapView?.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Me"
        self.myMapView?.addAnnotation(pin)
        
        populateNearByPlaces(region)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .green
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    func populateNearByPlaces(_ region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.place
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            guard let response = response else {
                return
            }
            print(response.mapItems)
            for item in response.mapItems {
        
                let annotation = PlaceAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                self.myMapView.addAnnotation(annotation)
                
                
            }
            
        }
        
    }
    
}


