//
//  menuTableView.swift
//  foober1.0
//
//  Created by Amos Gwa on 12/3/16.
//  Copyright © 2016 Colorado School of Mines. All rights reserved.
//

import UIKit

class menuTableView: UITableViewController {
    var menu : [item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menu.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! menuCell

        // Configure the cell...
        
        cell.foodImage.image = menu[indexPath.row].image
        cell.itemPrice.text = "$ \(menu[indexPath.row].price)"
        cell.itemName.text = menu[indexPath.row].name
        cell.chosenItem = menu[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showItemDetail")
        {
            let viewController: ItemDetailViewController = segue.destination as! ItemDetailViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            
            viewController.chosenItem = menu[indexPath.row]
            
            //self.present(viewController, animated: true, completion: nil)
        }
    }
}
