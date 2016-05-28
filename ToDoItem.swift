//
//  ToDoItem.swift
//  Another To Do List
//
//  Created by Brent Ellis on 1/26/16.
//  Copyright © 2016 Brent Ellis. All rights reserved.
//

import Foundation

class ToDo: NSObject, NSCoding {
    static var key: String = "ToDos"
    static var schema: String = "theList"
    var objective: String
    var finishedToDo: Bool
    var finishedToDoAt: NSDate
    var createdAt: NSDate
    
    init(obj: String) {
        objective = obj
        finishedToDo = false
        finishedToDoAt = NSDate()
        createdAt = NSDate()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(objective, forKey: "objective")
        aCoder.encodeObject(finishedToDo, forKey: "finishedToDo")
        aCoder.encodeObject(createdAt, forKey: "createdAt")
        aCoder.encodeObject(finishedToDoAt, forKey: "finishedToDoAt")
    }
    
    required init?(coder aDecoder: NSCoder) {
        objective = aDecoder.decodeObjectForKey("objective") as! String
        finishedToDo = aDecoder.decodeObjectForKey("finishedToDo") as! Bool
        createdAt = aDecoder.decodeObjectForKey("createdAt") as! NSDate
        finishedToDoAt = aDecoder.decodeObjectForKey("finishedToDoAt") as! NSDate
        super.init()
    }
    
    static func all() -> [ToDo] {
        var toDos = [ToDo]()
        let path = Database.dataFilePath("theList")
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                toDos = unarchiver.decodeObjectForKey(ToDo.key) as! [ToDo]
                unarchiver.finishDecoding()
            }
        }
        return toDos
    }
    
    func save() {
        var toDosFromStorage = ToDo.all()
        var exists = false
        for var i = 0; i < toDosFromStorage.count; ++i {
            if toDosFromStorage[i].createdAt == self.createdAt {
                toDosFromStorage[i] = self
                exists = true
            }
        }
        if !exists {
            toDosFromStorage.append(self)
        }
        Database.save(toDosFromStorage, toSchema: ToDo.schema, forKey: ToDo.key)
    }
    
    func remove() {
        var toDosFromStorage = ToDo.all()
        var foundIt = false
        var i: Int
        for i = 0; i < toDosFromStorage.count; ++i {
            if toDosFromStorage[i].createdAt == self.createdAt {
                foundIt = true
                break
            }
        }
        if foundIt {
            toDosFromStorage.removeAtIndex(i)
            Database.save(toDosFromStorage, toSchema: ToDo.schema, forKey: ToDo.key)
        }
    }
    
    func done() {
        var toDosFromStorage = ToDo.all()
        var foundIt = false
        var i: Int
        for i = 0; i < toDosFromStorage.count; ++i {
            if toDosFromStorage[i].createdAt == self.createdAt {
                foundIt = true
                break
            }
        }
        if foundIt {
            toDosFromStorage[i].finishedToDo = true
            toDosFromStorage[i].save()
        }
    }
    
    func unDone() {
        var toDosFromStorage = ToDo.all()
        var foundIt = false
        var i: Int
        for i = 0; i < toDosFromStorage.count; ++i {
            if toDosFromStorage[i].createdAt == self.createdAt {
                foundIt = true
                break
            }
        }
        if foundIt {
            toDosFromStorage[i].finishedToDo = false
            toDosFromStorage[i].save()
        }
    }
    
    static func unfinished() -> [ToDo] {
        var unfinishedToDos = [ToDo]()
        let toDosFromStorage = ToDo.all()
        var i: Int
        for i = 0; i < toDosFromStorage.count; ++i {
            if toDosFromStorage[i].finishedToDo == false {
                unfinishedToDos.append(toDosFromStorage[i])
            }
        }
        return unfinishedToDos
    }
    
    static func finished() -> [ToDo] {
        var finishedToDos = [ToDo]()
        let toDosFromStorage = ToDo.all()
        var i: Int
        for i = 0; i < toDosFromStorage.count; ++i {
            if toDosFromStorage[i].finishedToDo == true {
                finishedToDos.append(toDosFromStorage[i])
            }
        }
        return finishedToDos
    }
    
}