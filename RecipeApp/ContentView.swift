//
//  ContentView.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

struct ContentView: View {
    @State private var userLoggedIn: Bool? // nil for loading, true for logged in, false for not logged in
    
    
    var body: some View {
        Group {
            if let isLoggedIn = userLoggedIn {
                if isLoggedIn {
                    TabView {
                        RecipesView()
                            .tabItem {
                                Image(systemName: "book.closed.fill")
                                Text("Recipes")
                            }
                       
                        Settings()
                            .tabItem {
                                Image(systemName: "gearshape.fill")
                                Text("Settings")
                            }
                    }
                } else {
                    // User is not logged in, show login or signup view
                    LoginLogout(userLoggedIn: $userLoggedIn)
                }
            } else {
                // Loading state, show loading indicator
                ProgressView("Verifying...")
            }
        }
        .onAppear {
            verifyUserAuthentication()
        }
        
    }
    
    func verifyUserAuthentication() {
        Auth.auth().addStateDidChangeListener { auth, user in
            userLoggedIn = user != nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
