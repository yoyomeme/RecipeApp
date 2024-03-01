//
//  User.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI

struct User: Identifiable {
    var id: String { uid }
    var email : String
    var userName : String
    var uid : String
    var profileURL : String

}
