//
//  ContentView.swift
//  Todo
//
//  Created by Developer on 9/13/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import SwiftUI
import CoreData
import ChameleonFramework

struct CategoryList: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest var categories: FetchedResults<Category>
    
    @State var showModal: Bool = false
    @State var newItem: String = ""
    @State var filter: String = ""
    
    init(){
        let request = Category.fetchRequest(predicate: NSPredicate(format: "TRUEPREDICATE"))
        _categories = FetchRequest(fetchRequest: request)
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(filter: $filter, items: "Categories")
                List {
                    ForEach(categories, id: \.id) { item in
                        Group{
                            if self.filter == "" || item.category.contains(self.filter){
                                NavigationLink(destination: TodoListView(category: item)) {
                                    Text(item.category)
                                }
                                .listRowBackground(Color(UIColor(hexString: item.color)!))
                            }
                        }
                    }
                    .onDelete { index in
                        Category.deleteCategory(category: self.categories[index.first!], context: self.context)
                    }
                }
                .navigationBarTitle("Categories")
                .navigationBarItems(trailing: Button(action: {
                    self.showModal = true
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                }))
            }
        }
        .sheet(isPresented: $showModal) {
            AddModal(newItem: self.$newItem, showModal: self.$showModal).environment(\.managedObjectContext, self.context)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryList()
    }
}
