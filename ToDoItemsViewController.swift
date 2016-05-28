//
//  ToDoItemsViewController.swift
//  Another To Do List
//
//  Created by Brent Ellis on 1/26/16.
//  Copyright © 2016 Brent Ellis. All rights reserved.
//

import UIKit

class ToDoItemsViewController: UITableViewController, CancelButtonDelegate, ToDoDetailsViewControllerDelegate {
    
    var unfinishedToDos: [ToDo]?
    
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
 
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .AllowAnimatedContent, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ToDoCell")!
        let currentToDo = unfinishedToDos![indexPath.row]
        cell.textLabel?.text = currentToDo.objective
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        unfinishedToDos = ToDo.unfinished()
//        print(unfinishedToDos)
        return unfinishedToDos!.count
    }
    
    //Once Add Button Is Pressed Segue Is Performed To Create New ToDo Item
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("ToDoDetails", sender: nil)
    }
       
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ToDoDetails") {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ToDoDetailsViewController
            controller.cancelButtonDelegate = self
            controller.delegate = self
            if sender != nil {
                if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                    controller.toDoToEdit = unfinishedToDos![indexPath.row]
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }

    //Creates An Edit & Delete Button With Left Swipe
        //Edit Button triggers segue to edit todo item
        //Delete Button deletes todo item and reloads the data
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let editButton = UITableViewRowAction(style: .Normal, title: "Edit", handler: {action, indexPath in
            tableView.setEditing(false, animated: true)
            self.performSegueWithIdentifier("ToDoDetails", sender: tableView.cellForRowAtIndexPath(indexPath))
            tableView.reloadData()
            print("Edit Button Pressed")
        });
        
        let deleteButton = UITableViewRowAction(style: .Destructive, title: "Delete", handler: {action, indexPath in
            let deleteToDo = self.unfinishedToDos![indexPath.row]
            deleteToDo.remove()
            tableView.reloadData()
            print("Delete Button Pressed")
        });
        
        let doneButton = UITableViewRowAction(style: .Normal, title: "Done", handler: {action, indexPath in
            let doneToDo = self.unfinishedToDos![indexPath.row]
            doneToDo.done()
            tableView.reloadData()
        });
        doneButton.backgroundColor = UIColor.blueColor()
        
        return [deleteButton, editButton, doneButton]
    }
        
    func toDoDetailsViewController() {
        dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
    
}


