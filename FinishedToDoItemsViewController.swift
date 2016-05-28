//
//  FinishedToDoItemsViewController.swift
//  Another To Do List
//
//  Created by Brent Ellis on 1/29/16.
//  Copyright © 2016 Brent Ellis. All rights reserved.
//

import UIKit


class FinishedToDoItemsViewController: UITableViewController, CancelButtonDelegate, ToDoDetailsViewControllerDelegate, FinishedToDoItemsDelegate {
    
    var adding = true
    var finishedToDos = ToDo.finished()
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("FinishedToDoCell")!
        let currentFinishedToDo = finishedToDos[indexPath.row]
        cell.textLabel?.text = currentFinishedToDo.objective
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        finishedToDos = ToDo.finished()
        return finishedToDos.count
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let unDoneButton = UITableViewRowAction(style: .Normal, title: "Not Done", handler: {action, indexPath in
            let doneToDo = self.finishedToDos[indexPath.row]
            doneToDo.unDone()
            tableView.reloadData()
        });
        unDoneButton.backgroundColor = UIColor.blueColor()
        
        let deleteButton = UITableViewRowAction(style: .Destructive, title: "Delete", handler: {action, indexPath in
            let deleteToDo = self.finishedToDos[indexPath.row]
            deleteToDo.remove()
            tableView.reloadData()
            print("Delete Button Pressed")
        });
        
        
        return [deleteButton, unDoneButton]
    }
    
    func toDoDetailsViewController() {
        dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
    
}
