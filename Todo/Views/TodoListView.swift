//
//  TodoListView.swift
//  Todo
//
//  Created by Developer on 9/13/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import SwiftUI
import ChameleonFramework

struct TodoListView: View {
    var category: Category
    @State var filter: String = ""
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest var todos: FetchedResults<TodoItem>
    
    @State var showModal: Bool = false
    @State var newItem: String = ""
    
    init(category: Category){
        self.category = category
        let request = TodoItem.fetchRequest(predicate: NSPredicate(format: "category_ = %@", self.category.category))
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
                                                .foregroundColor(Color(ContrastColorOf(UIColor(hexString: self.category.color)!.darken(byPercentage: CGFloat(self.todos.firstIndex(of: item)!) / CGFloat(self.todos.count))!, returnFlat: true)))
                                            Spacer()
                                            if item.completed{
                                                Image(systemName: "checkmark").foregroundColor(Color(ContrastColorOf(UIColor(hexString: self.category.color)!.darken(byPercentage: CGFloat(self.todos.firstIndex(of: item)!) / CGFloat(self.todos.count))!, returnFlat: true)))
                                            }
                                        }
                                    }
                                .listRowBackground(Color(UIColor(hexString: self.category.color)!.darken(byPercentage: CGFloat(self.todos.firstIndex(of: item)!) / CGFloat(self.todos.count))!))
                                }
                            }
                        }.onDelete { index in
                            let item = self.todos[index.first!]
                            TodoItem.deleteTodo(todo: item, context: self.context)
                        }
                }
                .navigationBarTitle(self.category.category)
                .navigationBarItems(trailing: Button(action: {
                    self.showModal = true
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
            }))
            }
        }
        .sheet(isPresented: $showModal) {
            AddModal(newItem: self.$newItem, showModal: self.$showModal, title: self.category.category).environment(\.managedObjectContext, self.context)
        }
    }
}


//struct TodoListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoListView(title: "")
//    }
//}
