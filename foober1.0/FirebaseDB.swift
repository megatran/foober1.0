//
//  FirebaseDB.swift
//  kitchenFirebase
//
//  Created by Amos Gwa on 11/16/16.
//  Copyright © 2016 Amos Gwa. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDB {
    
    let ref = FIRDatabase.database().reference()
    var Kitchens:[kitchen] = []
    
    struct K {
        static let kitchenKey = "kitchens"
        static let nameKey = "Name"
    }
    
    func addKitchen(_ kitchen: kitchen) {
        // always start with the top level-node
        // grab its child named "Kitchen", or create it if needed
        // add a child node of "Kitchen" with where node key = kitchen.id
        // set the value for the key to a dictionary
        
        print("Adding new kitchen")
        
        ref.child(K.kitchenKey).child(kitchen.id).setValue(
            [K.nameKey: "Yolo",
             ])
    }
    
    func removeKitchen(_ id: String) {
        ref.child(K.kitchenKey).child(id).removeValue()
    }
    
    func updateKitchen(_ kitchen: kitchen) {
        ref.child(K.kitchenKey).child(kitchen.id).updateChildValues(
            [K.nameKey: kitchen.name
            ])
    }
    
    /**
     Convert a FIRDataSnapshot object to a Kitchen object.
     Parameters: accepts a FIRDataSnapshot that
     contains a single child node of Kitchen
     Returns: a Kitchen object created from the FIRDataSnapshot data
     **/
    func convertSnapshotToKitchenObject(_ snap: FIRDataSnapshot) -> kitchen {
        let kitchenResult = kitchen()
        
        let kitchenValues = snap.value as! [String : AnyObject]
        // pull out the kitchen id
        // this is the name of the node, not in the node content
        let id = snap.key
        // pull out the other properties
        // make sure the key actually exists before using it,
        // something like...
        kitchenResult.id = id
        kitchenResult.name = kitchenValues[K.nameKey] == nil ? "" : kitchenValues[K.nameKey]! as! String
        
        // TODO: repeat for each property in Kitchen
        // TODO: return a kitchen object with the properties set
        return kitchenResult
    }
    
    // Setup observers that perform a closure each time a kitchen is added,
    // removed, or changed
    func setupDBListeners() {
        print("Listening")
        // listen for new Kitchen added
        // also, let’s make sure it returns each kitchen in order by name
        ref.child(K.kitchenKey)
            .queryOrdered(byChild: K.nameKey)
            .observe(.childAdded, with: { (snapshot) in
                let kitchen = self.convertSnapshotToKitchenObject(snapshot)
                
                // Check if the current array already contains the kitchen with the id.
                let index = self.findKitchen(kitchen_id: kitchen.id);
                
                //print("Printing added kitchen")
                //kitchen.printkitchen()
                
                // Make sure that the kitchen is a new kitchen.
                // Otherwise update the old one.
                if index < 0 {
                    self.Kitchens.append(kitchen)
                } else {
                    self.updateKitchen(kitchen)
                }
                
                //print("Kitchen size : \(self.kitchens.count)")
                //self.libraryTableView.reloadData()                // TODO: insert kitchen obj into the local kitchen array
                // TODO: reload the tableview (you may need a delegate)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataUpdated"), object: nil, userInfo: ["kitchens" : self.Kitchens])
            })
        
        // listen for changes in kitchen data
        ref.child(K.kitchenKey)
            .observe(.childChanged, with: { (snapshot) in
                let kitchen = self.convertSnapshotToKitchenObject(snapshot)
                
                let index = self.findKitchen(kitchen_id: kitchen.id);
                
                // Make sure that the index is updated. Otherwise, add this kitchen as a new kitchen.
                if index < 0 {
                    self.addKitchen(kitchen)
                } else {
                    self.Kitchens[index] = kitchen
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataUpdated"), object: nil, userInfo: ["kitchens" : self.Kitchens])
                //self.libraryTableView.reloadData()
                // TODO: update the correct kitchen in your array
                // TODO: reload the tableview
            })
        // listen for kitchens removed
        ref.child(K.kitchenKey)
            .observe(.childRemoved, with: { (snapshot) in
                
                let kitchen = self.convertSnapshotToKitchenObject(snapshot)
                
                let index = self.findKitchen(kitchen_id: kitchen.id);
                
                // Make sure that the index is updated. Otherwise, add this kitchen as a new kitchen.
                if index > 0 {
                    self.Kitchens.remove(at: index)
                    //self.libraryTableView.reloadData()
                }
                // TODO: remove the proper kitchen from the array
                // TODO: update the tableview
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataUpdated"), object: nil, userInfo: ["kitchens" : self.Kitchens])
            })
    }
    
    func findKitchen(kitchen_id: String) -> Int {
        for i in 0..<self.Kitchens.count {
            if self.Kitchens[i].id == kitchen_id{
                return i
            }
        }
        return -1
    }
    
    func insertData() -> Void {
        let tmp = kitchen()
        tmp.id = "100"
        tmp.name = "Hello"
        addKitchen(tmp)
    }
}

let database = FirebaseDB()
