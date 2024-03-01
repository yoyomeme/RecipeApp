//
//  UpdateUserDetails.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI

struct UpdateUserDetails: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    var profileUrl: URL?
    @State var profileName: String
    @State var availability: Bool
    @State private var email: String = "" // Add a state variable for email
    @State private var profileURLString: String = "" // Add a state variable for profile URL string
    
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.5), Color.orange.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            NavigationView {
                Form {
                    Section(header: Text("Profile")) {
                        TextField("Name", text: $profileName)
                        TextField("Email", text: $email) // Add a TextField for email
                        TextField("Profile URL", text: $profileURLString) // Add a TextField for profile URL
                    }
                    Section {
                        Button("Save") {
                            
                            dataManager.updateUserDetails(name: profileName, email: email, profileURL: profileURLString)
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Update Profile")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                .onAppear {
                    // Initialize the form with current user details
                    if let profileUrl = profileUrl {
                        profileURLString = profileUrl.absoluteString
                    }
                    if let currentUser = dataManager.currentUser {
                        email = currentUser.email
                    }
                }
            }
        }
    }

}
