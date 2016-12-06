//
//  loginViewController.swift
//  foober1.0
//
//  Created by Amos Gwa on 12/3/16.
//  Copyright © 2016 Colorado School of Mines. All rights reserved.
//

import UIKit
import Firebase

var isAuthenticated = false
class loginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var isLogin = true
    var users : [user] = [] {
        didSet {
            self.printUsers();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Query users data
        database.getUserInfo()
        addObservers()
        
        if isLogin {
            titleLabel.text = "Login"
        } else {
            titleLabel.text = "Register"
        }
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(loginViewController.updateUsers), name: NSNotification.Name(rawValue: "userUpdated"), object: nil)
    }
    
    func updateUsers(notification: NSNotification) {
        print("notification \(notification)")
        let updatedUsers = notification.userInfo as! Dictionary<String, [user]>
        
        //let updatedUsers = notification.userInfo as! Dictionary<String, user>
        print("loginView")
        self.users = updatedUsers["users"]!
        
        //self.users = updatedUsers["users"]!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginBttnPressed(_ sender: UIButton) {
        if checkUser(username: usernameField.text!, password: passwordField.text!) {
            isAuthenticated = true
            performSegue(withIdentifier: "authenticatedSegue", sender: nil)
        } else {
            // Display Error message.
            showAlert(message: "Please check your username or password.")
        }
    }

    @IBAction func registerBttnPressed(_ sender: UIButton) {
    }
    
    
    func checkUser(username: String, password: String) -> Bool{
        for i in self.users {
            if(i.username == username) {
                if(i.password == password) {
                    return true;
                } else {
                    return false;
                }
            }
        }
        
        return false;
    }
    
    func printUsers() {
        print("=============Printing users :=============")
        for i in 0..<self.users.count {
            self.users[i].printUser();
        }
        print("==========================================")
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
