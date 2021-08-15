//
//  SimpleNotesTableViewController.swift
//  Simple Notes
//
//  Created by Naira Bassam on 06/08/2021.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class SimpleNotesTableViewController: SwipeTableViewController {
    
//    var itemArray = [Item]()
//    var selectedCategory: Category? {
//        didSet{
//            loadItem()
//        }
//    }
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var itemArray = [Item2]()
    
    let realm = try! Realm()
    var items: Results<Item2>?
    var selectedCategory: Category2? {
        didSet{
            loadItem()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        if let categoryColour = selectedCategory?.color {
            searchBar.barTintColor = UIColor(hexString: categoryColour)
            searchBar.searchTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            title = selectedCategory!.name
//            self.navigationController?.navigationBar.barTintColor = UIColor(hexString: categoryColour)
            let app = UINavigationBarAppearance()
            app.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.9543606639, green: 0.9001446962, blue: 0.6991648078, alpha: 1), .font: UIFont(name: "Noteworthy-Bold", size: 40.0)!]
            app.backgroundColor = UIColor(hexString: categoryColour)
            self.navigationController?.navigationBar.scrollEdgeAppearance = app
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return itemArray.count
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let item = itemArray[indexPath.row]
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let colour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)){
                cell.backgroundColor = colour
//                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No item added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = itemArray[indexPath.row]
//        context.delete(item)
//        itemArray.remove(at: [indexPath.row])
//        if let item = itemArray[indexPath.row] {
//            item.done = !item.done
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//        saveItems()
        if let item = items?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            }catch{
                print("Error updating done status, \(error)")
            }
            tableView.reloadData()
        }
    }
    //MARK:- Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.items?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(itemForDeletion)
                }
            }catch{
                print("Error deleting category, \(error)")
            }
        }
    }
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
       
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            guard let newNote = textField.text else {return}
//            let newItem = Item(context: self.context)
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item2()
                        newItem.title = newNote
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error saving context, \(error)")
                }
            }
            self.tableView.reloadData()
//            self.itemArray.append(newItem)
//            self.saveItems()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    
    func loadItem(){
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
//    func saveItems() {
//        do {
//            try context.save()
//        }catch {
//             print("Error saving context, \(error)")
//        }
//    
//        tableView.reloadData()
//    }
    
//    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        }catch {
//            print("Error fetching data from context, \(error)")
//        }
//        tableView.reloadData()
//    }
    
}

//MARK: - Extension for creating searchBar

extension SimpleNotesTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItem(with: request, predicate: predicate)
        
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }
}
