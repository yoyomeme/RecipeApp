//
//  AddRecipe.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    @Binding var isPresented: Bool
    @State private var selectedUIImage: UIImage?
    @State private var ingredients: String = "abc"
    @State private var steps: String = "abc"
    @State private var recipeName: String = "abc"
    @State private var selectedRecipeType: RecipeType?
    @State private var recipeTypes: [RecipeType] = [] // Initialize as empty and load in onAppear
    
    
    var body: some View {
        NavigationView {
            VStack {
                // ImageSelection component for selecting or capturing an image
                ImageSelection(selectedImage: $selectedUIImage)
                    .padding(.bottom) // Add some padding below the image selection
                
                Form {
                    Section(header: Text("Name")) {
                        TextField("Recipe Name", text: $recipeName)
                        
                    }
                    Section(header: Text("Recipe Type")) {
                        Picker("Select a recipe type", selection: $selectedRecipeType) {
                            ForEach(recipeTypes, id: \.self) { recipeType in
                                Text(recipeType.name).tag(recipeType)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    Section(header: Text("Ingredients")) {
                        TextField("Ingredients", text: $ingredients)
                    }
                    Section(header: Text("Cooking Steps")) {
                        TextField("Steps", text: $steps)
                    }
                }
                .navigationTitle("Add Your Secret Recipe")
                .navigationBarTitleDisplayMode(.inline)
                //.navigationTitle( Text("Add Your Secret Recipe").font(.title2).bold())
                .toolbar (content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isPresented = false
                        } label: {
                            Label("Back", systemImage: "chevron.backward")
                                .labelStyle(.iconOnly)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button ("Done") {
                            //save logic right here
                            isPresented = false
                        }
                    }
                })
                .onAppear {
                    // Load and parse the XML data when the view appears
                    recipeTypes = loadAndParseXML()
                }
            }
        }
    }
    func loadAndParseXML() -> [RecipeType] {
        guard let xmlPath = Bundle.main.path(forResource: "recipetypes", ofType: "xml"),
              let xmlData = try? Data(contentsOf: URL(fileURLWithPath: xmlPath)) else {
            return []
        }
        let parser = RecipeTypeParser()
        return parser.parseRecipeTypes(xmlData: xmlData)
    }
}

