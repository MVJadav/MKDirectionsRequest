//
//  MapKitVC.swift
//  Gmap
//
//  Created by MV Jadav on 18/07/17.
//  Copyright © 2017 MV Jadav. All rights reserved.
//

import UIKit
import MapKit

class MapKitVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var IBMKMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        //self.setMap(Latitude: 21.282778, Longitude: -157.829444)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setMap(Latitude:Double, Longitude:Double) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            var mapRegion = MKCoordinateRegion()
            let Lat = Latitude
            let Long = Longitude
            let Coordinates = CLLocationCoordinate2D(latitude: Lat as CLLocationDegrees, longitude: Long as CLLocationDegrees)
            mapRegion.center = Coordinates;
            mapRegion.span.latitudeDelta    = 0.002
            mapRegion.span.longitudeDelta   = 0.002
            self.IBMKMapView.setRegion(mapRegion, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = Coordinates
            annotation.title = "Maninagar"
            annotation.subtitle = "Ahmedabad"
            self.IBMKMapView.addAnnotation(annotation)
            
            self.IBMKMapView.delegate = self
        }
    }
   
}

//https://github.com/ioscreator/ioscreator/blob/master/IOS9DrawRouteMapKitTutorial/IOS9DrawRouteMapKitTutorial/ViewController.swift
//MARK: - IOS9 DrawRoute MapKit Tutorial
extension MapKitVC {
 
    func setData() {
        
        // 1.
        IBMKMapView.delegate = self
        // 2.
        
        let sourceLocation = CLLocationCoordinate2D(latitude: 22.998674, longitude: 72.611415)
        let destinationLocation = CLLocationCoordinate2D(latitude: 23.022622, longitude: 72.543009)
        
//        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
//        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Maninagar"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Prahlad Nagar"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.IBMKMapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    // https://www.apple.com/ios/feature-availability/#maps-directions
                    // https://stackoverflow.com/questions/19035752/display-route-between-two-points-on-map-with-mapkit-ios7
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.IBMKMapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.IBMKMapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
}


