//
//  ItemsViewController.swift
//  RealHomepwner
//
//  Created by Paul Baker on 2/21/19.
//  Copyright © 2019 Paul Baker. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    // The edit button in the navigation Bar
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // Updates the view with the edited information
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.reloadData()
    }
    
    // This edits the word from "Delete" to "Terminate"
    override func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath:IndexPath) ->String?
    { return "Terminate"
    }
    
    var itemStore: ItemStore!
    
    // The add button
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
        
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, wher n = row this cell
        //will appear in on the tableview
        let item = itemStore.allItems[indexPath.row]
        
        // Configure the cell with the Item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        // This modifies the text color depending on item value 
        if item.valueInDollars > 50 {
            cell.valueLabel.textColor = .red
        } else {
            cell.valueLabel.textColor = .green
        }
        
        return cell
    }
    // This allows for rows to be moved
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to ommit a delete command...
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            // Checking if the user really wants to delete an item
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                // Remove the item from the store
                self.itemStore.removeItem(item)
                
                // Also remove that row from the table view with an animation
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            ac.addAction(deleteAction)
            
            // Present the alert controller
            present(ac, animated: true, completion: nil)

        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
   
    // This switches from the items view to the details view and
    // indicates which item is being shown and gives and error if there isn't
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                
                // Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController
                    = segue.destination as! DetailViewController
                detailViewController.item = item
            }
            
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    
    
}
