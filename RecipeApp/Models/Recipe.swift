//
//  Recipe.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI

struct Recipe: Identifiable {
  
    var ingredients : String
    var steps : String
    var id : String
    var imageURL : String
    var recipeType : String
}
