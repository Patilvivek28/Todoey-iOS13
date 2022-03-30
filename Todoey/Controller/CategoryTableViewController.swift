//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Patil, Vivek on 30/03/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        loadCategories()
    }

    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK: - Data manipulation methods
    
    func save(category: Category) {
        // Saving data in Realm
        
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
//    func loadCategories(_ request: NSFetchRequest<Category> = Category.fetchRequest()) {
//
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching categories, \(error)")
//        }
//
//        tableView.reloadData()
//
//    }
    
    
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text ?? "New Category"
            
            self.categoryArray.append(newCategory)
            self.save(category: newCategory)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
