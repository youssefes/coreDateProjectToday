//
//  catagoresViewController.swift
//  coreDateProjectToday
//
//  Created by youssef on 7/31/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import CoreData
class catagoresViewController: UITableViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var catagories  = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    // MARK :- tableView DtaaSourse
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catagories", for: indexPath)
        let name = catagories[indexPath.row].name
        cell.textLabel?.text = name
        
        return cell
    }
    
    // MARK :- tableView Dalaget
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToItemSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destainationVc = segue.destination as! TodayeListViewController
        if let indexpath = tableView.indexPathForSelectedRow{
            destainationVc.selectCatagory = catagories[indexpath.row]
            
        }
        
    }
    
    //MARK : - Maniplated Mathods
    
    func save(){
        do{
           try context.save()
        }catch{
            print(error)
        }
        
    }
    
    func loadData(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            catagories = try context.fetch(request)
            
        }catch{
           print(error)
        }
        tableView.reloadData()
    }
    
    //MARK :- addNew Ite Using bar button

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "new Name", message: "add New Name", preferredStyle: .alert)
        
        let saveaction = UIAlertAction(title: "add Name", style: .default) { (action) in
            
            guard let textField = alert.textFields?.first, let nameTosave = textField.text else{
                return
            }
            
            let catagory = Category(context: self.context)
            catagory.name = nameTosave
            self.catagories.append(catagory)
            self.save()
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addTextField()
        alert.addAction(cancel)
        alert.addAction(saveaction)
        
        present(alert, animated: true, completion: nil)
        
    }
}
