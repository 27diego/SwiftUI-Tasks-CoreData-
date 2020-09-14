//
//  Todo.swift
//  Todo
//
//  Created by Developer on 9/13/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation
import CoreData

extension TodoItem {
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<TodoItem> {
        let request = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "task_", ascending: true)]
        return request
    }
    
    static func addNewTodo(todo: String, category: String, context: NSManagedObjectContext){
        let newTodo = TodoItem(context: context)
        newTodo.category = category
        newTodo.task = todo
        newTodo.completed = false
        newTodo.id = UUID()
        
        newTodo.objectWillChange.send()
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func deleteTodo(todo: TodoItem, context: NSManagedObjectContext){
        context.delete(todo)
        try? context.save()
    }
    
    static func completeTodo(todo: TodoItem, context: NSManagedObjectContext) {
        todo.completed = !todo.completed
        try? context.save()
    }
    
    var category: String {
        get { category_ ?? "unknown" }
        set { category_ = newValue }
    }
    
    var completed: Bool {
        get { completed_ }
        set { completed_ = newValue }
    }
    
    var id: UUID {
        get { id_ ?? UUID() }
        set { id_ = newValue }
    }
    
    var task: String {
        get { task_ ?? "unknown" }
        set { task_ = newValue }
    }
}
