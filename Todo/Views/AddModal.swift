//
//  AddModal.swift
//  Todo
//
//  Created by Developer on 9/13/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import SwiftUI

struct AddModal: View {
    @Binding var newItem: String
    @Binding var showModal: Bool
    
    var title = ""
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationView {
            HStack{
                TextField("Add Item", text: $newItem)
                    .padding()
                    .background(Color(.systemGray6))
                Button(action: {
                    if self.title != "" {
                        TodoItem.addNewTodo(todo: self.newItem, category: self.title, context: self.context)
                        self.newItem = ""
                    }
                    else{
                        Category.addCategory(category: self.newItem, context: self.context)
                    }
                    self.showModal = false
                }, label: {
                    Text("OK")
                })
            }
            .navigationBarTitle(title == "" ? "New Category" : "New Todo")
            .padding(.horizontal, 16)
        }
    }
}

struct AddModal_Previews: PreviewProvider {
    static var previews: some View {
        AddModal(newItem: .constant(""), showModal: .constant(true))
    }
}
