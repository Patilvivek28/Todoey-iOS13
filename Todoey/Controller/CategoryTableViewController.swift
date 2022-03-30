//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Patil, Vivek on 30/03/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hexString: "007AFF")
        navBar.standardAppearance = appearance;
        navBar.scrollEdgeAppearance = navBar.standardAppearance
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            if let color = UIColor(hexString: category.color) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
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
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    //MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                    
                }
            } catch {
                print("error deleting category, \(error)")
            }
        }
    }
    
    
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text ?? "New Category"
            newCategory.color = UIColor.randomFlat().hexValue()
            
            // No need to manually update/append new category, it will be auto updated
            
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
