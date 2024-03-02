//
//  SearchBar.swift
//  RecipeApp
//
//  Created by Melon on 2/3/2024.
//

import SwiftUI

struct SearchBar: View {
    @State private var message = ""
    
    var body: some View {
        HStack{
            CustomTextField(placeholder: Text("Search ... ").font(.system(size: 14)), text: $message)
                //.frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            
            Button{
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue.opacity(1))
                    .cornerRadius(50)
            }
        }
        .padding(.leading, 10)
        //.padding(.vertical, 10)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(50)
        //.padding()
        
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View{
        SearchBar()
    }
}

struct CustomTextField: View {
    var placeholder: Text
    //@binding can pass a variable from one view to another, which also allows dynamic changes of that variable
    @Binding var text: String
    
    var editingChanged: (Bool) -> () = {_ in}//notify that the state has changes
    
    var commit: () -> () = {}//allows user to use return as enter
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                //.padding(.vertical ,10)
        }
    }
}
