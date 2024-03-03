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
    @State private var profileURLString: UIImage? // Add a state variable for profile URL string
    @State private var selectedUIImage: UIImage?
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.5), Color.orange.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    RecipeTitleRow(title: "Profile")
                        .padding(.top)
                    
                    // ImageSelection component for selecting or capturing an image
                    ImageSelection(selectedImage: $selectedUIImage)
                        .padding(.bottom)
                    
                    CustomTextFields(title: "Name", text: $profileName)
                    CustomTextFields(title: "Email", text: $email)
                    
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    guard let selectedImage = selectedUIImage else {
                        // Handle the case where no image is selected (if that's acceptable in your app logic)
                        print("No profile image selected")
                        return
                    }
                    
                    dataManager.updateUserDetails(name: profileName, email: email, profileImage: selectedImage) { success, error in
                        if success {
                            // Handle success, e.g., show an alert or dismiss the view
                            alertMessage = "User details updated successfully."
                            showAlert = true
                            dismiss() // dismiss the view upon successful update
                        } else if let error = error {
                            // Handle error, e.g., show an error message
                            alertMessage = "Error updating user details: \(error.localizedDescription)"
                            showAlert = true
                        }
                    }
                }) {
                    Text("Update Details")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
            }
            .onAppear {
                // Initialize the form with current user details
              
                if let currentUser = dataManager.currentUser {
                    email = currentUser.email
                }
                
                if let profileImageUrl = profileUrl {
                    URLSession.shared.dataTask(with: profileImageUrl) { data, response, error in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.selectedUIImage = image
                            }
                        } else {
                            // Handle errors or set a default image
                            DispatchQueue.main.async {
                                self.selectedUIImage = nil // Or set a default placeholder image
                            }
                        }
                    }.resume()
                }
            }
            
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
}
