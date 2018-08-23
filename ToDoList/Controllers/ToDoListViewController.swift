//
//  ViewController.swift
//  ToDoList
//
//  Created by Sierra on 20/08/18.
//  Copyright © 2018 Sierra. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let newItem = Item()
            newItem.title = "A"
            newItem.done = true
            itemArray.append(newItem)
        
            let newItem2 = Item()
            newItem2.title = "B"
            itemArray.append(newItem2)
        
            let newItem3 = Item()
            newItem3.title = "C"
            itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoList") as? [Item] {
            itemArray = items
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListitemcell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New to ToDoList", message : "", preferredStyle : .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in

            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ToDoList")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

