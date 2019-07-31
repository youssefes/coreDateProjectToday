//
//  ViewController.swift
//  coreDateProjectToday
//
//  Created by youssef on 7/27/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import CoreData

class TodayeListViewController : UITableViewController  {

    
    var selectCatagory : Category?{
        didSet{
            leadItem()
        }
    }
    var arrayItem = [Item]()
    let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayeListViewController", for: indexPath)
        
        let item = arrayItem[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MArk : Updata value 
        //self.arrayItem[indexPath.row].setValue("completed", forKey: "title")
        self.arrayItem[indexPath.row].done = !self.arrayItem[indexPath.row].done
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addnewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
        
            
            let items = Item(context: self.context)
            items.title = textField.text
            items.done = false
            items.parentCatagory = self.selectCatagory
            self.arrayItem.append(items)
            
            self.saveItem()
        }))
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "add New Item "
            textField = alertTextfield
        }
        present(alert, animated: true, completion: nil)
    }
    //Mark - Save Data
    func saveItem(){
        do{
            try context.save()
        }catch{
            print("\(error)")
        }
        self.tableView.reloadData()
    }
    // MARK - Load Data
    func leadItem(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)  {
        
        let catagoryPerdicate = NSPredicate(format: "parentCatagory.name MATCHES %@", self.selectCatagory!.name!)
        
        if let additionPrdicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catagoryPerdicate,additionPrdicate])
        }else{
            request.predicate = catagoryPerdicate
        }
        
        do{
            arrayItem = try context.fetch(request)
        }catch{
            print(error)
        }
        
        tableView.reloadData()
    }
    
}
//MARK - Search Bar Mathods
extension TodayeListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        guard  let searchText = searchBar.text else{
            return
        }
        request.predicate  = NSPredicate(format: "title CONTAINS [cd] %@", searchText)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        leadItem(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            leadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

