//
//  FirstViewController.swift
//  foober1.0
//
//  Created by megatran on 11/20/16.
//  Copyright © 2016 Colorado School of Mines. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    private var kitchens : [kitchen] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Set a distance filter: only notify the delegate when device has
        // moved xx meters. For no filter, set to kCLDistanceFilterNone.
        locationManager.distanceFilter = 5.0
        
        locationManager.requestWhenInUseAuthorization()
        
        if let location = locationManager.location {
            // Define the region of the map to be displayed. The span is in meters.
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 600.0,
                                                            600.0)
            
            // Animate changing the currently visible region.
            mapView.setRegion(region, animated: true)
            
            dummyKitchen()
            zoomMapView()
            dropPin()
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:
        [CLLocation]) {
        if let location = locationManager.location {
            // Define the region of the map to be displayed. The span is in meters.
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 600.0,
                                                            600.0)
            
            // Animate changing the currently visible region.
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:
        CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation=true
        } else {
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation=false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let cLError = error as! CLError
        var errorType = String()
        
        // See https://developer.apple.com/reference/corelocation/clerror.code for all
        // codes.
        switch cLError.code {
        case .denied:
            errorType="Location service denied by user"
        case .locationUnknown:
            errorType="Location can't be determined right now"
        default:
            errorType = error.localizedDescription
        }
        
        let alert = UIAlertController(title: "Location access error", message: errorType,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dummyKitchen() {
        for _ in 0...50 {
            let tmpKitchen = kitchen()
            tmpKitchen.address = "1230 ABC Rd"
            tmpKitchen.name = "Loc"
            
            var lat_random = Double(randomInt(min: 0, max: 9))
            var long_random = Double(randomInt(min: 0, max: 9))
            let lat_divisor = Double(randomInt(min: 100, max: 1000))
            let long_divisor = Double(randomInt(min: 500, max: 1500))
            
            let negative = Double(randomInt(min: -1, max: 0))
            
            if negative < 0{
                lat_random *= negative
                long_random *= negative
            }
            
            tmpKitchen.location = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! + lat_random/lat_divisor, longitude: (locationManager.location?.coordinate.longitude)! + long_random/long_divisor)
            
            kitchens.append(tmpKitchen)
        }
    }
    
    func dropPin() {
        
        for var item in kitchens {
                let annotation = MKPointAnnotation()
                //let longitude = locationManager.location?.coordinate.longitude
                //let latitude = (locationManager.location?.coordinate.latitude)! + 0.0005
                
                //annotation.coordinate =  CLLocationCoordinate2DMake(latitude, longitude!)
                annotation.coordinate = item.location
                annotation.title = item.name
                annotation.subtitle = item.address
                mapView.addAnnotation(annotation)
        }
    }
    
    func findCenter()->MKCoordinateRegion {
        
        var min_long: Double = 0.0
        var max_long : Double = 0.0
        var min_lat : Double = 0.0
        var max_lat : Double = 0.0
        var center_lat : Double = 0.0
        var center_long : Double = 0.0
        
        for i in 0..<kitchens.count {
            if kitchens[i].location.latitude > max_lat{
                max_lat = kitchens[i].location.latitude
            }
            if kitchens[i].location.latitude < min_lat{
                min_lat = kitchens[i].location.latitude
            }
            if kitchens[i].location.longitude > max_long{
                max_long = kitchens[i].location.longitude
            }
            if kitchens[i].location.longitude < min_long{
                min_long = kitchens[i].location.longitude
            }
            
            center_lat = center_lat + kitchens[i].location.latitude;
            center_long = center_long + kitchens[i].location.longitude;
        }
        
        center_lat = (max_lat + min_lat) / 2;
        center_long = (max_long + min_long) / 2;
        
        print("Center is \(center_lat) : \(center_long)")
        
        var deltaLat = abs(max_lat - min_lat);
        var deltaLong = abs(max_long - min_long);
        
        //set minimal delta
        if (deltaLat < 5) {deltaLat = 5;}
        if (deltaLong < 5) {deltaLong = 5;}
        
        var region : MKCoordinateRegion = self.mapView.region
        region.center = CLLocationCoordinate2D(latitude: center_lat, longitude: center_long)
        
        region.span.longitudeDelta = deltaLong // Bigger the value, closer the map view
        region.span.latitudeDelta /= deltaLat
        
        return region
    }
    
    func zoomMapView(){
        print("setting region")
        var region: MKCoordinateRegion = findCenter()
        self.mapView.setRegion(region, animated: true) // Choose if you want animate or not
    }
    
    
    //Utility
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}

