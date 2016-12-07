//
//  kitchenAnnotation.swift
//  foober1.0
//
//  Created by Amos Gwa on 11/21/16.
//  Copyright © 2016 Colorado School of Mines. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import UIKit

class kitchenAnnotation : NSObject, MKAnnotation {
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    
    var title: String? = ""
    var subtitle: String? = ""
    var kitchenPin = kitchen()
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
}
