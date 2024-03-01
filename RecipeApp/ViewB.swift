//
//  ViewB.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI
import PhotosUI

struct ViewB: View {
    @State private var selectedUIImage: UIImage?
    @State private var ingredients: String = ""
    @State private var steps: String = ""
    @State private var recipeName: String = ""
    @State private var selectedRecipeType: RecipeType?
    @State private var recipeTypes: [RecipeType] = []
    
    @State private var showAlert = false // State to manage alert visibility
    @State private var alertMessage = "" // State to manage alert message
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.5), Color.orange.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            ScrollView {
                VStack {
                    RecipeTitleRow(title: "Add Recipe")
                    // ImageSelection component for selecting or capturing an image
                    ImageSelection(selectedImage: $selectedUIImage)
                        .padding(.bottom) // Add some padding below the image selection
                    
                    // Name Section
                    VStack(alignment: .leading) {
                        Text("Name")
                            .font(.headline)
                            .padding(.top)
                        ZStack(alignment: .topLeading) {
                            Rectangle()
                                .frame(height: 100)
                                .foregroundColor(.white.opacity(0.5)) // Make the rectangle invisible
                                .border(Color(UIColor.separator), width: 0.5) // Add a border to the rectangle
                            TextField("Recipe Name", text: $recipeName)
                                .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle to remove padding
                                .padding(10) // Add padding inside the ZStack to position the text field correctly
                        }
                        .padding(.horizontal)
                    }
                    
                    // Recipe Type Section
                    VStack(alignment: .leading) {
                        Text("Recipe Type")
                            .font(.headline)
                            .padding(.top)
                        Picker("Select a recipe type", selection: $selectedRecipeType) {
                            ForEach(recipeTypes, id: \.self) { recipeType in
                                Text(recipeType.name).tag(recipeType)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .padding(.horizontal)
                    }
                    
                    // Ingredients Section
                    VStack(alignment: .leading) {
                        Text("Ingredients")
                            .font(.headline)
                            .padding(.top)
                        ZStack(alignment: .topLeading) {
                            Rectangle()
                                .frame(height: 100)
                                .foregroundColor(.white.opacity(0.5)) // Make the rectangle invisible
                                .border(Color(UIColor.separator), width: 0.5) // Add a border to the rectangle
                            TextField("Ingredients", text: $ingredients)
                                .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle to remove padding
                                .padding(10) // Add padding inside the ZStack to position the text field correctly
                        }
                        .padding(.horizontal)
                    }
                    
                    // Cooking Steps Section
                    VStack(alignment: .leading) {
                        Text("Cooking Steps")
                            .font(.headline)
                            .padding(.top)
                        ZStack(alignment: .topLeading) {
                            Rectangle()
                                .frame(height: 100)
                                .foregroundColor(.white.opacity(0.5))
                                .border(Color(UIColor.separator), width: 0.5) // Add a border to the rectangle
                            TextField("Cooking Steps", text: $steps)
                                .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle to remove padding
                                .padding(10) // Add padding inside the ZStack to position the text field correctly
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                Button(action: addRecipe) {
                    Text("Add Recipe")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Add Your Secret Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            recipeTypes = loadAndParseXML()
        }
    }
    
    private func addRecipe() {
        dataManager.addRecipe(recipeName: recipeName, ingredients: ingredients, steps: steps, recipeType: selectedRecipeType, selectedImage: selectedUIImage) { success, error in
            if success {
                alertMessage = "Recipe has been added successfully."
            } else {
                alertMessage = "Error adding recipe: \(error?.localizedDescription ?? "Unknown error")"
            }
            showAlert = true
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


struct ViewB_Previews: PreviewProvider {
    static var previews: some View {
        ViewB().environmentObject(DataManager())
    }
}


