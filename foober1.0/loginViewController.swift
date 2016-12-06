//
//  loginViewController.swift
//  foober1.0
//
//  Created by Amos Gwa on 12/3/16.
//  Copyright © 2016 Colorado School of Mines. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBttnPressed(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: usernameField.text!, password: passwordField.text!, completion: {
            user, error in
            
            if error != nil {
                self.login()
                
            } else {
                print("User Created")
                self.login()
            }
        })
    }
    
    func login() {
        FIRAuth.auth()?.signIn(withEmail: usernameField.text!, password: passwordField.text!, completion: {
            user, error in
            
            if error != nil {
                print("Incorrect")
            } else {
                print("log in")
            }
        })
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
