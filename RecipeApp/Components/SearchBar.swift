//
//  SearchBar.swift
//  RecipeApp
//
//  Created by Melon on 2/3/2024.
//

import SwiftUI

struct SearchBar: View {
    @State private var message = ""
    @State private var isEditing = false
    @State private var recipeTypes: [RecipeType] = []
    
    // Define the grid layout
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        VStack {
            HStack {
                CustomTextField(placeholder: Text("Search ... ").font(.system(size: 14)), text: $message)
                    .frame(width: 150)
                    .onTapGesture {
                        self.isEditing = true
                    }
                
                Button {
                    // Perform search
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue.opacity(1))
                        .cornerRadius(50)
                }
            }
            .padding(.leading, 10)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(50)
            
            // Display the grid of recipe types when editing
            if isEditing {
                ZStack {
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.isEditing = false
                        }
                    
                    // Your existing ScrollView and LazyVGrid for displaying RecipeTypes
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(recipeTypes, id: \.id) { type in
                                Button(type.name) {
                                    // Handle selection
                                    print("Selected \(type.name)")
                                    self.isEditing = false
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
            }
        }
        .onAppear {
            loadRecipeTypes()
        }
        // Transparent overlay to capture taps outside the search bar
        if isEditing {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    self.isEditing = false
                }
                .zIndex(-1) // Ensure the overlay is behind the search content
        }
    }
    
    func loadRecipeTypes() {
        // Assuming you have a function to load XML data from your local file
        if let xmlData = loadXMLDataFromFile() {
            let parser = RecipeTypeParser()
            self.recipeTypes = parser.parseRecipeTypes(xmlData: xmlData)
        }
    }
    
    // Placeholder function for loading XML data from a local file
    func loadXMLDataFromFile() -> Data? {
        // Implement loading of XML data from your local file
        return nil
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
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
