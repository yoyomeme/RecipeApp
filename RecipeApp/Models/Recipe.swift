//
//  Recipe.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI
import FirebaseFirestoreSwift


struct Recipe: Codable, Identifiable {
    
    @DocumentID var id: String?
    
    var name: String
    var type: String
    var ingredients: String
    var steps: String
    var imageUrl: String
    
}
