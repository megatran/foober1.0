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
    var users : [user] = []
    
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
        // Do any additional setup after loading the view.
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(loginViewController.updateUsers), name: NSNotification.Name(rawValue: "userUpdated"), object: nil)
    }
    
    func updateUsers(notification: NSNotification) {
        print("notification \(notification)")
        let updatedUsers = notification.userInfo as! Dictionary<String, [user]>
        
        
        self.users = updatedUsers["users"]!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBttnPressed(_ sender: UIButton) {
        //isAuthenticated = true
        if isAuthenticated {
            // Check the database against.
            performSegue(withIdentifier: "authenticatedSegue", sender: self)
        } else {
            // Display Error message.
        }
    }

    @IBAction func registerBttnPressed(_ sender: UIButton) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
