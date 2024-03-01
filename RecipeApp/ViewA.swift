//
//  ViewA.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI

struct ViewA: View {
    
    @State private var selectedRecipeType: RecipeType?
    @State private var showingAddSheet = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.5), Color.orange.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView { // Wrap your content in a ScrollView
                VStack(spacing: 20) {
                   
                        RecipeTitleRow(title: "Recipe")
                        Text("View A")

                }
            }
        }
    }
}




struct ViewA_Previews: PreviewProvider {
    static var previews: some View {
        ViewA()
    }
}

