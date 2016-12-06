//
//  launchScreenViewController.swift
//  foober1.0
//
//  Created by Amos Gwa on 12/3/16.
//  Copyright © 2016 Colorado School of Mines. All rights reserved.
//

import UIKit

class launchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
            
//            OperationQueue.main.addOperation {
//                [weak self] in
//                self?.performSegue(withIdentifier: "loggedInSegue", sender: self)
//            }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
    }

    @IBAction func signupPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "loginSegue" {
            let LV = segue.destination as! loginViewController
            LV.isLogin = true
        } else if segue.identifier == "signupSegue" {
            let LV = segue.destination as! loginViewController
            LV.isLogin = false
        } else if segue.identifier == "loggedInSegue" {
            print("logged In")
            //let LV = segue.destination as! UITabBarController
        }
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
