//
//  TodoListView.swift
//  Todo
//
//  Created by Developer on 9/13/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import SwiftUI

struct TodoListView: View {
    var title: String
    @State var filter: String = ""
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest var todos: FetchedResults<TodoItem>
    
    @State var showModal: Bool = false
    @State var newItem: String = ""
    
    init(title: String){
        self.title = title
        let request = TodoItem.fetchRequest(predicate: NSPredicate(format: "category_ = %@", self.title))
        _todos = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(filter: $filter, items: "")
                List {
                    ForEach(todos, id: \.id) { item in
                        Group{
                            if self.filter == "" || item.task.contains(self.filter){
                                Button(action: {
                                        TodoItem.completeTodo(todo: item, context: self.context)
                                    }) {
                                        HStack{
                                            Text(item.task)
                                            Spacer()
                                            if item.completed{
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            }
                        }.onDelete { index in
                            let item = self.todos[index.first!]
                            TodoItem.deleteTodo(todo: item, context: self.context)
                        }
                }
                .navigationBarTitle(self.title)
                .navigationBarItems(trailing: Button(action: {
                    self.showModal = true
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
            }))
            }
        }
        .sheet(isPresented: $showModal) {
            AddModal(newItem: self.$newItem, showModal: self.$showModal, title: self.title).environment(\.managedObjectContext, self.context)
        }
    }
}


struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(title: "")
    }
}
