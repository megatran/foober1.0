//
//  kitchen.swift
//  foober1.0
//
//  Created by Amos Gwa on 11/21/16.
//  Copyright © 2016 Colorado School of Mines. All rights reserved.
//

import Foundation
import CoreLocation

class kitchen {
    var id = UUID().uuidString
    var name : String = ""
    var address : String = ""
    var menu : [item] = []
    var location = CLLocationCoordinate2D()
}
