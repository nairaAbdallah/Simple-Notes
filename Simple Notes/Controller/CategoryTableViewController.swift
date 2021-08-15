//
//  CategoryTableViewController.swift
//  Simple Notes
//
//  Created by Naira Bassam on 09/08/2021.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
  
//    var categoryArray = [Category]()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let realm = try! Realm()
    var catgories: Results<Category2>?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let app = UINavigationBarAppearance()
        app.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.9543606639, green: 0.9001446962, blue: 0.6991648078, alpha: 1), .font: UIFont(name: "Noteworthy-Bold", size: 40.0)!]
        app.backgroundColor = #colorLiteral(red: 0.6717447079, green: 0.3722832495, blue: 0.1999010568, alpha: 1)
        self.navigationController?.navigationBar.scrollEdgeAppearance = app
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadCategory()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catgories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = catgories?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.color)
        }else{
            cell.textLabel?.text = "No category added yet"
            cell.backgroundColor = UIColor(hexString: "AB5F33")
            
        }
       
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let distenationVC = segue.destination as! SimpleNotesTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            distenationVC.selectedCategory = catgories?[indexPath.row]
        }
    }
    //MARK: - Data Manipulation Methods
    
//    func saveCategory() {
//        do {
//            try context.save()
//            }
//        }catch {
//             print("Error saving context, \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
//        func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//
//            do {
//                categoryArray = try context.fetch(request)
//            }catch {
//                print("Error fetching data from context, \(error)")
//            }
//            tableView.reloadData()
//        }
    func save(category: Category2) {
        do {
            try realm.write{
                realm.add(category)
            }
        }catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    func loadCategory(){
        catgories = realm.objects(Category2.self)
        
        tableView.reloadData()
    }

    //MARK:- Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.catgories?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category, \(error)")
            }
        }
    }
    
    
    //MARK: - Add New Category
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
       
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let newCategory = textField.text else {return}
//            let newItem = Category(context: self.context)
            let newItem = Category2()
            newItem.name = newCategory
            newItem.color = UIColor.randomFlat().hexValue()
//            self.categoryArray.append(newItem)
//            self.saveCategory()
            self.save(category: newItem)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
}


