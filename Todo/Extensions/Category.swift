//
//  Category.swift
//  Todo
//
//  Created by Developer on 9/13/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation
import CoreData

extension Category {
    
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<Category> {
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "category_", ascending: true)]
        return request
    }
    
    static func addCategory(category: String, context: NSManagedObjectContext){
        let newCategory = Category(context: context)
        newCategory.category = category
        newCategory.id = UUID()
        
        newCategory.objectWillChange.send()
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    static func deleteCategory(category: Category, context: NSManagedObjectContext){
        let request = TodoItem.fetchRequest(predicate: NSPredicate(format: "category_ = %@", category.category))
        let todos = (try? context.fetch(request)) ?? []
        
        for item in todos {
            TodoItem.deleteTodo(todo: item, context: context)
        }
        
        context.delete(category)
        try? context.save()
    }
    
    
    var category: String {
        get { category_ ?? "unknown" }
        set { category_ = newValue }
    }
    
    var id: UUID {
        get { id_ ?? UUID() }
        set { id_ = newValue }
    }
}
