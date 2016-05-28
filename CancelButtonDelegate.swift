//
//  CancelButtonDelegate.swift
//  Another To Do List
//
//  Created by Brent Ellis on 1/26/16.
//  Copyright © 2016 Brent Ellis. All rights reserved.
//

import UIKit

protocol CancelButtonDelegate: class {
    
    func cancelButtonPressedFrom(controller: UIViewController)
    
}
