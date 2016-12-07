//
//  ItemDetailViewController.swift
//  foober1.0
//
//  Created by Amos Gwa on 12/6/16.
//  Copyright © 2016 Colorado School of Mines. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    
    var chosenItem = item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.itemName.text = chosenItem.name
        self.image.image = chosenItem.image
        self.priceLabel.text = "$ \(chosenItem.price)"
        self.descriptionField.text = chosenItem.description
        
        self.descriptionField.isEditable = false
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func orderBttnPressed(_ sender: Any) {
        //Add to my order list
        myOrders.append(chosenItem)
        print("Ordered")
        showAlert(message: "Ordered \(chosenItem.name)")
    }
    
    @IBAction func cancelBttnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Enjoy!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
