//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCore

@main
struct RecipeAppApp: App {
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(dataManager)
        }
    }
}
