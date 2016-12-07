//
//  FirebaseDB.swift
//  kitchenFirebase
//
//  Created by Amos Gwa on 11/16/16.
//  Copyright © 2016 Amos Gwa. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class FirebaseDB {
    
    let ref = FIRDatabase.database().reference()
    
    var Kitchens:[kitchen] = []
    var Users:[user] = []
    
    struct K {
        static let kitchenKey = "kitchens"
        static let nameKey = "name"
        static let menuKey = "menu"
    }
    
    struct U {
        static let userKey = "users"
        static let passwordKey = "password"
        static let ordersKey = "orders"
    }
    
    func getUserInfo() {
        print("FirebaseDB : Getting user Info")
        ref.child(U.userKey)
            .queryOrderedByValue()
            .observe(.childAdded, with: { (snapshot) in
                
                let tmp_user = self.convertSnapshotToUserObject(snapshot)
                
                // Check if the current array already contains the user with the username.
                let index = self.findUser(username: tmp_user.username);
                
                //print("Printing added kitchen")
                //kitchen.printkitchen()
                
                // Make sure that the kitchen is a new user.
                // Otherwise update the old one.
                if index < 0 {
                    tmp_user.printUser()
                    self.Users.append(tmp_user)
                } else {
                    self.updateUser(tmp_user)
                }
                
                // TODO: reload the tableview (you may need a delegate)
                self.printUsers()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userUpdated"), object: nil, userInfo: ["users" : self.Users])
            })
        
    }
    
    
    
    func addKitchen(_ kitchen: kitchen) {
        // always start with the top level-node
        // grab its child named "Kitchen", or create it if needed
        // add a child node of "Kitchen" with where node key = kitchen.id
        // set the value for the key to a dictionary
        
        print("FirebaseDB : Adding new kitchen")
        
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
    
    func addUser(_ user: user) {
        // always start with the top level-node
        // grab its child named "Kitchen", or create it if needed
        // add a child node of "Kitchen" with where node key = kitchen.id
        // set the value for the key to a dictionary
        
        print("FirebaseDB : Adding new user")
        
        ref.child(U.userKey).child(user.username).setValue(
            [U.userKey: user.username,
             U.passwordKey: user.password,
             U.ordersKey: user.orders
             ])
    }
    
    func removeUser(_ username: String) {
        ref.child(U.userKey).child(username).removeValue()
    }
    
    func updateUser(_ user: user) {
        ref.child(U.userKey).child(user.username).updateChildValues(
            [U.userKey: user.username,
             U.passwordKey: user.username
            ])
    }
    
    func addOrder(_  username: String, item_id: UUID, amount: Int) {
        ref.child(U.userKey).child(username).child(U.ordersKey).setValue(
            [
                item_id: amount,
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
        let itemResult = item()
        
        print("FirebaseDB : kitchen span \(snap)")
//        "Aunty Betty_1": {
//            "menu": {
//                "Fried Chicken": {
//                    "quantity": 10,
//                    "image" : "friedchicken",
//                    "description": "Fried chicken tastes so good!"
//                },
//                "Mashed Potato": {
//                    "quantity": 9,
//                    "image" : "mashedpotato",
//                    "description": "Hello"
//                }
//            }
//        },
        let kitchenName = snap.key
        let kitchenMenu = snap.value as! [String : AnyObject]
        let menuList = kitchenMenu[K.menuKey] as! [String : AnyObject]
        
        let latitude = kitchenMenu["latitude"] as! String
        let longitude = kitchenMenu["longitude"] as! String
        
        let rating = kitchenMenu["rating"] as! Double
        
        kitchenResult.location = CLLocationCoordinate2D(latitude: Double(latitude)!,longitude: Double(longitude)!)
        kitchenResult.rating = rating     
        
        
        
        for item in menuList{
            let properties = item.value as! [String : AnyObject]
            let quantity = properties["quantity"] as! Int
            let description = properties["description"] as! String
            let image = properties["image"] as! String
            let price = properties["price"] as! Double
            let itemName = item.key
            
            itemResult.name = itemName
            itemResult.image = UIImage(named: image)!
            itemResult.description = description
            itemResult.price = price
            itemResult.quantity = quantity
            
            kitchenResult.name = kitchenName
            
            
            print("adding \(itemResult.name)")
            kitchenResult.menu.append(itemResult)
        }
                
        // TODO: repeat for each property in Kitchen
        // TODO: return a kitchen object with the properties set
        kitchenResult.printKitchen()
        
        return kitchenResult
    }
    
    func convertSnapshotToUserObject(_ snap: FIRDataSnapshot) -> user {
        let userResult = user()
        
        let userResults = snap.value as! [String : AnyObject]
        
        print("FirebaseDB : userResults : \(userResults)")
        // pull out the kitchen id
        // this is the name of the node, not in the node content
        let username = snap.key
        // pull out the other properties
        // make sure the key actually exists before using it,
        // something like...
        userResult.username = username
        userResult.password = userResults[U.passwordKey] == nil ? "" : userResults[U.passwordKey]! as! String
        userResult.orders = userResults[U.ordersKey] as! [String : AnyObject]
        
        print("FirebaseDB : userResult : ")
        userResult.printUser()
        
        // TODO: repeat for each property in Kitchen
        // TODO: return a kitchen object with the properties set
        return userResult
    }
    
    // Setup observers that perform a closure each time a kitchen is added,
    // removed, or changed
    func setupDBListeners() {
        print("FirebaseDB : Listening")
        // listen for new Kitchen added
        // also, let’s make sure it returns each kitchen in order by name
        ref.child(K.kitchenKey)
            .queryOrdered(byChild: K.nameKey)
            .observe(.childAdded, with: { (snapshot) in
                let kitchen = self.convertSnapshotToKitchenObject(snapshot)
                
                // Check if the current array already contains the kitchen with the id.
                let index = self.findKitchen(kitchen_name: kitchen.name);
                
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kitchenUpdated"), object: nil, userInfo: ["kitchens" : self.Kitchens])
            })
        
        // listen for changes in kitchen data
        ref.child(K.kitchenKey)
            .observe(.childChanged, with: { (snapshot) in
                let kitchen = self.convertSnapshotToKitchenObject(snapshot)
                
                let index = self.findKitchen(kitchen_name: kitchen.name);
                
                // Make sure that the index is updated. Otherwise, add this kitchen as a new kitchen.
                if index < 0 {
                    self.addKitchen(kitchen)
                } else {
                    self.Kitchens[index] = kitchen
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kitchenUpdated"), object: nil, userInfo: ["kitchens" : self.Kitchens])
                //self.libraryTableView.reloadData()
                // TODO: update the correct kitchen in your array
                // TODO: reload the tableview
            })
        // listen for kitchens removed
        ref.child(K.kitchenKey)
            .observe(.childRemoved, with: { (snapshot) in
                
                let kitchen = self.convertSnapshotToKitchenObject(snapshot)
                
                let index = self.findKitchen(kitchen_name: kitchen.name);
                
                // Make sure that the index is updated. Otherwise, add this kitchen as a new kitchen.
                if index > 0 {
                    self.Kitchens.remove(at: index)
                    //self.libraryTableView.reloadData()
                }
                // TODO: remove the proper kitchen from the array
                // TODO: update the tableview
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kitchenUpdated"), object: nil, userInfo: ["kitchens" : self.Kitchens])
            })
    }
    
    func findKitchen(kitchen_name: String) -> Int {
        for i in 0..<self.Kitchens.count {
            if self.Kitchens[i].name == kitchen_name{
                return i
            }
        }
        return -1
    }
    
    func findUser(username: String) -> Int {
        for i in 0..<self.Users.count {
            if self.Users[i].username == username{
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
    
    // Utility functions
    func printUsers() {
        print("FirebaseDB : ")
        print("=============Printing users :=============")
        for i in 0..<self.Users.count {
            self.Users[i].printUser();
        }
        print("==========================================")
    }
}

let database = FirebaseDB()
