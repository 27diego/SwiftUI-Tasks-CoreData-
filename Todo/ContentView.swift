//
//  ContentView.swift
//  Todo
//
//  Created by Developer on 9/13/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import SwiftUI
import CoreData

struct ItemListView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest var todos: FetchedResults<Todo>
    
    @State var showModal: Bool = false
    @State var newItem: String = ""
    
    init(){
        let request = Todo.fetchRequest(predicate: NSPredicate(format: "TRUEPREDICATE"))
        _todos = FetchRequest(fetchRequest: request )
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(todos, id: \.id) { item in
                    Text(item.task)
                }
            }
        .navigationBarTitle("ToDos")
            .navigationBarItems(trailing: Button(action: {
                self.showModal = true
            }, label: {
                Image(systemName: "plus.circle")
                    .foregroundColor(.blue)
            }))
        }
        .sheet(isPresented: $showModal) {
            addModal(newItem: self.$newItem, showModal: self.$showModal).environment(\.managedObjectContext, self.context)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}


struct addModal: View {
    @Binding var newItem: String
    @Binding var showModal: Bool
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack{
            TextField("Add Item", text: $newItem)
            Button(action: {
                Todo.addNewTodo(todo: self.newItem, category: "Car", context: self.context)
            }, label: {
                Text("OK")
            })
        }
    }
}
