//
//  RecipeView.swift
//  RecipeApp
//
//  Created by Melon on 2/3/2024.
//

import SwiftUI

struct RecipeView: View {
    var recipe: Recipe // Assuming Recipe is your model
    @Environment(\.dismiss) var dismiss
    
    @State private var showingEditSheet = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: recipe.imageUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .overlay(alignment: .bottom) {
                                    
                                }
                        case .empty, .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100, alignment: .center)
                                .foregroundColor(.white.opacity(0.5))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    // .frame(height: 200) // Set a fixed height for the image
                    
                    
                    VStack(spacing: 30) {
                        Text(recipe.name)
                            .font(.largeTitle)
                            .padding()
                            .multilineTextAlignment(.center)
                        VStack(spacing: 30) {
                            Text(recipe.name)
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Ingredients")
                                    .font(.headline)
                                Text(recipe.ingredients)
                            }
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Steps")
                                    .font(.headline)
                                Text(recipe.steps)
                            }
                            
                        }
                        .padding(.horizontal)
                        
                    }
                }
                //.navigationTitle(recipe.name)
                .navigationBarTitleDisplayMode(.inline)
            }
            VStack {
                Spacer()
                HStack(alignment: VerticalAlignment.bottom) {
                    Spacer()
                    Button(action: {
                        //showingUpdateSheet.toggle()
                        showingEditSheet = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 24)) // Set the size of the SF Symbol
                            .foregroundColor(.white.opacity(0.7))
                            .padding(10)
                            .background(.blue.opacity(0.7))
                            .cornerRadius(50)
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showingEditSheet) {
                        AddView(recipeToEdit: recipe) {
                            dismiss()
                        }
                            }
                    //.ignoresSafeArea()
                }
            }
            
            
        }
    }
    
    struct RecipeView_Previews: PreviewProvider {
        static var previews: some View {
            RecipeView(recipe: Recipe(id: "Test Recipe", name: "sdf", type: "asd", ingredients: "Test Ingredients", steps: "Test Steps", imageUrl: "https://example.com/image.jpg"))
        }
    }
}
