//
//  ViewC.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI
import FirebaseAuth

struct ViewC: View {
    // Placeholder for user data
    // In a real app, you might fetch this data from your DataManager or directly from Firebase
    @EnvironmentObject var dataManager: DataManager
    
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
                    if let user = dataManager.currentUser {
                        
                        TitleRow(profileUrl: URL(string: user.profileURL), profileName: user.userName, availability: true)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(user.userName)")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Email: \(user.email)")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                        .padding()
                    } else {
                        Text("Loading user data...")
                    }
                    
                    Spacer()
                    
                    Button(action: logout) {
                        Text("Logout")
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .refreshable { // Add the .refreshable modifier
                dataManager.refreshUsers()
            }
            .onAppear {
                dataManager.fetchCurrentUser()
            }
            
        }
    }
    func logout() {
        do {
            try Auth.auth().signOut()
            // Handle the UI change after logout if necessary
            dataManager.currentUser = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct ViewC_Previews: PreviewProvider {
    static var previews: some View {
        ViewC().environmentObject(DataManager())
    }
}


