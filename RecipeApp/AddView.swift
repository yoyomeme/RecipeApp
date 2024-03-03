//
//  ViewB.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI
import PhotosUI

struct AddView: View {
    @State private var selectedUIImage: UIImage?
    @State private var ingredients: String = ""
    @State private var steps: String = ""
    @State private var recipeName: String = ""
    @State private var selectedRecipeType: RecipeType?
    @State private var selectedRecipeTypeId: Int?
    @State private var recipeTypes: [RecipeType] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isUploading = false
    @State private var recipeToEdit: Recipe?
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var dataManager: DataManager
    
    @Environment(\.dismiss) private var dismissSheet // For iOS 15 and later
        var dismissParent: (() -> Void)?
    
    init(recipeToEdit: Recipe? = nil, dismissParent: (() -> Void)? = nil) {
        self._recipeToEdit = State(initialValue: recipeToEdit)
        self.dismissParent = dismissParent
        
    }

    
    var body: some View {
        
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.5), Color.orange.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if isUploading {
                ProgressView("Uploading...")
                    .padding()
            }
            ScrollView {
                VStack {
                    RecipeTitleRow(title: recipeToEdit == nil ? "Add Recipe" : "Edit Recipe")
                    
                    // ImageSelection component for selecting or capturing an image
                    ImageSelection(selectedImage: $selectedUIImage)
                        .padding(.bottom) 
                    
                    CustomTextFields(title: "Name", text: $recipeName)
                    
                    // Recipe Type Section
                    VStack(alignment: .leading) {
                        Text("Recipe Type")
                            .font(.headline)
                            .padding(.top)
                        Picker("Select a recipe type", selection: $selectedRecipeType) {
                            ForEach(recipeTypes, id: \.self) { recipeType in
                                Text(recipeType.name).tag(recipeType as RecipeType?)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .padding(.horizontal)
                        .onChange(of: selectedRecipeType) { newValue in
                            print("Recipe type changed to: \(newValue?.name ?? "nil")")
                        }
                    }
                    
                    CustomTextFields(title: "Ingredients", text: $ingredients)
                    
                    CustomTextFields(title: "Cooking Steps", text: $steps)
                    
                }
                
                Spacer()
                
                Button(action: recipeToEdit == nil ? addRecipe : updateRecipe) {
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
            if let recipeToEdit = recipeToEdit {
                // Populate the form with the recipe's details
                self.ingredients = recipeToEdit.ingredients
                self.steps = recipeToEdit.steps
                self.recipeName = recipeToEdit.name
                selectedRecipeType = recipeTypes.first { $0.name == recipeToEdit.type }
                
                // Asynchronously load the image from the URL
                if let imageUrl = URL(string: recipeToEdit.imageUrl) {
                    URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.selectedUIImage = image
                            }
                        } else {
                            // Handle errors or set a default image
                            DispatchQueue.main.async {
                                self.selectedUIImage = nil // Or set a default placeholder image
                            }
                        }
                    }.resume()
                }
            }
        }
        .onDisappear {
            // This ensures the recipes list is refreshed whenever AddView is dismissed
            dataManager.fetchRecipes()
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

extension AddView {
    private func addRecipe() {
        isUploading = true // Start uploading

        dataManager.addRecipe(recipeName: recipeName, ingredients: ingredients, steps: steps, recipeType: selectedRecipeType, selectedImage: selectedUIImage) { success, error in
            isUploading = false // End uploading
            if success {
                // Clear the text fields after successful upload
                recipeName = ""
                ingredients = ""
                steps = ""
                selectedRecipeType = nil
                selectedUIImage = nil
                
                //show a success message
                alertMessage = "Recipe has been added successfully."
                showAlert = true
                
                dismissSheet()
                
                // Dismiss ViewB to navigate back to ViewA
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    //self.presentationMode.wrappedValue.dismiss()
                    dismissParent?()
                }
            } else {
                // Handle the error case
                alertMessage = "Error adding recipe: \(error?.localizedDescription ?? "Unknown error")"
                showAlert = true
            }
        }
    }
    
    private func updateRecipe() {
        guard let recipeId = recipeToEdit?.id else {
            print("Error: Recipe ID is missing")
            return
        }

        isUploading = true // Start uploading

        // Call updateRecipe on the dataManager with the correct parameters
        dataManager.updateRecipe(recipeId: recipeId, recipeName: recipeName, ingredients: ingredients, steps: steps, recipeType: selectedRecipeType, selectedImage: selectedUIImage) { success, error in
            self.isUploading = false // End uploading
            if success {
                // Clear the text fields after successful upload
                self.recipeName = ""
                self.ingredients = ""
                self.steps = ""
                self.selectedRecipeType = nil
                self.selectedUIImage = nil

                // show a success message
                self.alertMessage = "Recipe has been updated successfully."
                self.showAlert = true

                // Dismiss the sheet and optionally the parent view
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.dismissSheet()
                    self.dismissParent?()
                }
            } else {
                // Handle the error case
                self.alertMessage = "Error updating recipe: \(error?.localizedDescription ?? "Unknown error")"
                self.showAlert = true
            }
        }
    }
}


