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

class kitchenAnnotation : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var phone: String!
    var name: String!
    var address: String!
    var image: UIImage!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
