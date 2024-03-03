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
                        HStack {
                            RecipeTitleRow(title: "Recipe")
                            Spacer()
                            SearchBar()
                            Spacer()
                            
                            Button(action: {
                                showingAddSheet = true
                            }) {
                                Image(systemName: "plus.app")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(50)
                            }
                            .navigationDestination(isPresented: $showingAddSheet) {
                                AddView()
                            }
                        }
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(dataManager.recipes) { recipe in
                                RecipeCard(recipeName: recipe.name, imageURL: recipe.imageUrl)
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                        // Handle long press
                                        self.recipeIdToDelete = recipe.id
                                        self.showingDeleteAlert = true
                                    }
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
                //                .navigationDestination(for: Recipe.self) { recipe in
                //                                RecipeView(recipe: recipe)
                //                            }
            }
            .onAppear {
                // Fetch recipes when the view appears
                dataManager.fetchRecipes()
            }
        }
        //        .navigationDestination(isPresented: $navigateToRecipeView) {
        //
        //
        //        (item: $selectedRecipe) { recipe in
        //             RecipeView(recipe: recipe)
        //        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeView(recipe: recipe)
        }
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView().environmentObject(DataManager())
    }
}
