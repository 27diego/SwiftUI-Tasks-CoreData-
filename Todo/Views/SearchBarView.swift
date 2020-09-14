//
//  SearchBarView.swift
//  Todo
//
//  Created by Developer on 9/13/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var filter: String
    var items: String
    var body: some View {
        ZStack{
            HStack {
                Image(systemName: "magnifyingglass")
                Spacer()
            }
            .padding()
            TextField("Filter \(items)", text: $filter)
                .padding()
                .padding(.leading, 25)
            
            if filter != "" {
                HStack{
                    Spacer()
                    Button(action: {
                        self.filter = ""
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
                .padding()
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(filter: .constant(""), items: "")
    }
}
