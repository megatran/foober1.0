//
//  kitchenInfoPopUpView.swift
//  foober1.0
//
//  Created by Amos Gwa on 12/3/16.
//  Copyright © 2016 Colorado School of Mines. All rights reserved.
//

import UIKit
import Cosmos

class kitchenInfoPopUpView: UIViewController {
    // Adding subview https://www.youtube.com/watch?v=FgCIRMz_3dE
    // Rating https://github.com/marketplacer/Cosmos
    @IBOutlet weak var kitchenName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet var rating: CosmosView!
    
    var chosenKitchen = kitchen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        // Do any additional setup after loading the view.
        
        
        self.kitchenName.text = chosenKitchen.name
        self.location.text = "Lat : \(chosenKitchen.location.latitude), Long : \(chosenKitchen.location.longitude)"
        
        
        if chosenKitchen.rating >= 4 {
            rating.settings.filledColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else if chosenKitchen.rating >= 3 {
            rating.settings.filledColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else {
            rating.settings.filledColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        
        rating.rating = chosenKitchen.rating
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBttnTapped(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }

    @IBAction func viewBttnTapped(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showMenuSegue")
        {
            let viewController: menuTableView = segue.destination as! menuTableView
            viewController.menu = chosenKitchen.menu
            print("Kitchen popUP \(chosenKitchen.menu[0].name), \(chosenKitchen.menu[1].name)")
            //self.present(viewController, animated: true, completion: nil)
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
