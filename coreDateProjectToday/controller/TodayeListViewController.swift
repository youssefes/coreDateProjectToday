//
//  ViewController.swift
//  coreDateProjectToday
//
//  Created by youssef on 7/27/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

class TodayeListViewController : UITableViewController  {

    var arrayItem = [item]()
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let items = item()
        items.title = "youssef"
        self.arrayItem.append(items)
        
        let items2 = item()
        items2.title = "yosef"
        self.arrayItem.append(items2)
        
        let items3 = item()
        items3.title = "yo"
        self.arrayItem.append(items3)
        
        
        if let items = defaults.object(forKey: "TodayList") as? [item]{
            arrayItem = items
        }
        
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
        
        self.arrayItem[indexPath.row].done = !self.arrayItem[indexPath.row].done
           
        
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addnewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
        
            let items = item()
            items.title = textField.text!
            self.arrayItem.append(items)
            self.defaults.setValue(self.arrayItem, forKey: "TodayList")
            
            
            self.tableView.reloadData()
        }))
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "add New Item "
            textField = alertTextfield
        }
        present(alert, animated: true, completion: nil)
    }
    
}

