//
//  customMV.swift
//  foober1.0
//
//  Created by Amos Gwa on 12/6/16.
//  Copyright © 2016 Colorado School of Mines. All rights reserved.
//

import Foundation
import MapKit

extension mapViewController: MKMapViewDelegate {
    
    // 1    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("Checking annotation")
        if annotation is kitchenAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinTintColor = .purple
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            let deleteButton = UIButton(type: UIButtonType.infoDark)
            deleteButton.frame.size.width = 44
            deleteButton.frame.size.height = 44
            //deleteButton.backgroundColor = UIColor.red
            //deleteButton.setImage(UIImage(named: "trash"), for: .normal)
            
            pinAnnotationView.rightCalloutAccessoryView = deleteButton
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? kitchenAnnotation {
            self.showKitchenDetailPopup(chosenKitchen : annotation.kitchenPin)
        }
    }
}
