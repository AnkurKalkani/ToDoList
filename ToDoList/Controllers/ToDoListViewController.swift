//
//  ViewController.swift
//  ToDoList
//
//  Created by Sierra on 20/08/18.
//  Copyright © 2018 Sierra. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{

    var itemArray = [Item]()
   
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
       
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New to ToDoList", message : "", preferredStyle : .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentcategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItem()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem() {
        do {
            try context.save()
        }
        catch {
            print("Error Saving Context : \(error)")
        }
        self.tableView.reloadData()
    }

    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentcategory.name MATCHES %@",selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
//        let compounPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//        request.predicate = compounPredicate
        
        do {
            itemArray = try context.fetch(request)
        }
        catch  {
            print("Nsfetchrequest error \(error)")
        }
        tableView.reloadData()
    }
    
}

extension ToDoListViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request)
        }
    }
    
}
