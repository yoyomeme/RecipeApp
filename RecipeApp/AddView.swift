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
    @State private var recipeTypes: [RecipeType] = []
    
    @State private var showAlert = false // State to manage alert visibility
    @State private var alertMessage = "" // State to manage alert message
    @State private var isUploading = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var dataManager: DataManager
    

    
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
                    RecipeTitleRow(title: "Add Recipe")
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
                                Text(recipeType.name).tag(recipeType)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .padding(.horizontal)
                    }
                    
                    CustomTextFields(title: "Ingredients", text: $ingredients)
                    
                    CustomTextFields(title: "Cooking Steps", text: $steps)
                    
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
                
                // Optionally, show a success message
                alertMessage = "Recipe has been added successfully."
                showAlert = true
                
                // Dismiss ViewB to navigate back to ViewA
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            } else {
                // Handle the error case
                alertMessage = "Error adding recipe: \(error?.localizedDescription ?? "Unknown error")"
                showAlert = true
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


//struct ViewB_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewB(selectedTab: .constant(0)))
//    }
//}


