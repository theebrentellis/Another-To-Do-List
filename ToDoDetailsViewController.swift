//
//  ToDoDetailsViewController.swift
//  Another To Do List
//
//  Created by Brent Ellis on 1/26/16.
//  Copyright © 2016 Brent Ellis. All rights reserved.
//

import UIKit

class ToDoDetailsViewController: UIViewController {
    
    weak var cancelButtonDelegate: CancelButtonDelegate?
    
    weak var delegate: ToDoDetailsViewControllerDelegate?
    
    var toDoToEdit: ToDo?
    
    @IBOutlet weak var newToDoTextField: UITextField!
    
    @IBOutlet weak var centerAlignText: NSLayoutConstraint!
    
    @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    
    @IBAction func doneBarButtonPressed(sender: UIBarButtonItem) {
        if newToDoTextField.text != "" {
            if let toDo = toDoToEdit {
                toDo.objective = newToDoTextField.text!
                toDo.save()
            } else {
                let toDo = ToDo(obj: newToDoTextField.text!)
                toDo.save()
            }
        }
        delegate?.toDoDetailsViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        centerAlignText.constant -= view.bounds.width
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        newToDoTextField.text = toDoToEdit?.objective
        
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.centerAlignText.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}
