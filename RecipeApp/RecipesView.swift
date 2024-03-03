//
//  ViewA.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI

struct RecipesView: View {
    
    @State private var selectedRecipeType: RecipeType?
    @State private var showingAddSheet = false
    
    @State private var showingDeleteAlert = false
    @State private var recipeIdToDelete: String?
    
    @State private var navigateToRecipeView = false
    @State private var selectedRecipe: Recipe?
    
    @EnvironmentObject var dataManager: DataManager
    
    @State private var searchText = ""
    
    @State private var searchTermBtn = ""
    
    @State private var recipeTypes: [String] = [] // Example data

    @State private var suggestionSelected = false

    
    //Define how many columns for the grid
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.5), Color.orange.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(dataManager.recipes) { recipe in
                                RecipeCard(recipeName: recipe.name, imageURL: recipe.imageUrl)
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                        // Handle long press
                                        self.recipeIdToDelete = recipe.id
                                        self.showingDeleteAlert = true
                                        // Trigger start haptic feedback
                                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                                    }
                                    .simultaneousGesture(
                                        DragGesture().onEnded { _ in
                                            // Handle drag end or long press end
                                            // Trigger end haptic feedback
                                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                        }
                                    )
                                    .highPriorityGesture(
                                        TapGesture().onEnded {
                                            print("Recipe selected: \(recipe.name)")
                                            self.selectedRecipe = recipe
                                        }
                                    )
                            }
                            .alert(isPresented: $showingDeleteAlert) {
                                Alert(
                                    title: Text("Delete Recipe"),
                                    message: Text("Are you sure you want to permanently delete this recipe?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        if let recipeId = recipeIdToDelete {
                                            dataManager.deleteRecipe(withId: recipeId) { success in
                                                if success {
                                                    // Handle successful deletion, e.g., refresh the recipe list
                                                    print("Recipe was successfully deleted.")
                                                } else {
                                                    // Handle failure
                                                    print("Failed to delete the recipe.")
                                                }
                                            }
                                        }
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }
            .onAppear {
                // Fetch recipes when the view appears
                dataManager.fetchRecipes()
                loadRecipeTypes()
            }
            .refreshable { // Add the .refreshable modifier
                dataManager.fetchRecipes()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Recipes")
                            .font(.system(size: 30))
                            .fontWeight(.heavy)
                    
                        Spacer()
                        Button(action: {
                            showingAddSheet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                                .padding(1)
                                .background(.white)
                                .cornerRadius(50)
                        }
                        .navigationDestination(isPresented: $showingAddSheet) {
                            AddView()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 60)
                    .padding(.bottom)
                }
            }
            .searchable(text: $searchText) {
                ForEach(searchResults, id: \.self) { result in
                    Text("Are you looking for \(result)?").searchCompletion(result)
                        .onTapGesture {
                            self.searchText = result
                            self.suggestionSelected = true
                        }
                }
            }
            .onChange(of: searchText) { newValue in
                // Reset suggestionSelected if the user modifies the search text
                if !suggestionSelected && !newValue.isEmpty {
                    suggestionSelected = false
                }

                // Determine the query field based on whether a suggestion was selected
                let queryField = suggestionSelected ? "type" : "name"
                
                // Perform the search
                dataManager.fetchRecipeSearch(queryField: queryField, searchTerm: newValue) { (recipes, error) in
                    if let recipes = recipes {
                        // Update the UI with the search results
                        self.dataManager.recipes = recipes
                    } else if let error = error {
                        // Handle the error
                        print("Error searching recipes: \(error.localizedDescription)")
                    }
                    // Reset suggestionSelected for the next search
                    self.suggestionSelected = false
                }
            }
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeView(recipe: recipe)
        }
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return recipeTypes
        } else {
            return recipeTypes.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func loadRecipeTypes() {
        if let xmlData = loadXMLData() {
            let parser = RecipeTypeParser()
            let types = parser.parseRecipeTypes(xmlData: xmlData)
            self.recipeTypes = types.map { $0.name }
        }
    }
    
    func loadXMLData() -> Data? {
        
        guard let fileURL = Bundle.main.url(forResource: "recipetypes", withExtension: "xml") else {
            print("XML file not found")
            return nil
        }
        return try? Data(contentsOf: fileURL)
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView().environmentObject(DataManager())
    }
}


