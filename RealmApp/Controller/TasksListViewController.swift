//
//  TasksListViewController.swift
//  RealmApp
//
//  Created by shmanai on 10/13/20.
//  Copyright © 2020 Anatoli Shmanai. All rights reserved.
//

import UIKit
import RealmSwift

class TasksListViewController: UITableViewController {
    
    var tasksLists: Results<TasksList>!

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksLists = realm.objects(TasksList.self)
        
        navigationItem.leftBarButtonItem = editButtonItem
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    
    
    @IBAction func addButtonPressed(_ sender: Any) {
    alertForAddAndUpdateList()
        tableView.reloadData()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        } else {tasksLists = tasksLists.sorted(byKeyPath: "date")}
        tableView.reloadData()
        
    }
    
    
    
    
    
    
    
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        
        let tasksList = tasksLists[indexPath.row]


        cell.configure(with: tasksList)

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let currentList = tasksLists[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            StorageManager.deleteList(currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { _, _ in
            self.alertForAddAndUpdateList(currentList, complition: {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
        
        let doneAction = UITableViewRowAction(style: .normal, title: "Done") { (_, _) in
            StorageManager.makeAllDone(currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        return [deleteAction, doneAction, editAction]
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let tasksList = tasksLists[indexPath.row]
            let tasksVC = segue.destination as! TasksViewController
            tasksVC.currentTasksList = tasksList
        }
        
    }

   
}


extension TasksListViewController {
    
    private func alertForAddAndUpdateList(_ listName: TasksList? = nil,
                                          complition:(() -> Void)? = nil) {
        
        
        var title = "New List"
        var doneButton = "Save"
        
        if listName != nil {
            title = "Edit List"
             doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        var alertTextField: UITextField!
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newList = alertTextField.text, !newList.isEmpty else { return }
            
            if let listName = listName {
                StorageManager.editList(listName, newListName: newList)
                if complition != nil { complition!() }
            } else {
                
                let tasksList = TasksList()
                tasksList.name = newList
                
                StorageManager.saveTasksList(tasksList)
                self.tableView.insertRows(at: [IndexPath(
                    row: self.tasksLists.count - 1, section: 0)], with: .automatic)  
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField{  textField in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }
        
        if let listName = listName {
            alertTextField.text = listName.name
        }
        
        present(alert, animated: true)
    }
}
