//
//  ViewController.swift
//  coreDateProjectToday
//
//  Created by youssef on 7/27/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

class TodayeListViewController : UITableViewController  {

    var arrayItem = ["Buy item","youssef","mohammed"]
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.stringArray(forKey: "TodayList"){
            arrayItem = items
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayeListViewController", for: indexPath)
        cell.textLabel?.text = arrayItem[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addnewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
        
            self.arrayItem.append(textField.text!)
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

