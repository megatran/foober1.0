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
        
        database.insertData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
    }

    @IBAction func signupPressed(_ sender: Any) {
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