//
//  LoginLogout.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginLogout: View {
    @Binding var userLoggedIn: Bool?
    @State private var email = ""
    @State private var userName = ""
    @State private var password = ""
    @State private var isSignIn = true //Toggle between sign in and sign up
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.5), Color.orange.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Recipe App")
                    .foregroundColor(.white)
                    .padding()
                    .font(.system(size: 35, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontDesign(Font.Design.monospaced)
                    .offset(x: 0, y: -100)
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                    .offset(x: 0, y: -100)
                
                TextField("Email", text: $email)
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .textFieldStyle(.plain)
                    .frame(width: 350, height: 50)
                    .background(RoundedRectangle(cornerRadius: 25.0).fill(Color.white).frame(width: 380, height: 50))
                    .placeholder(when: email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.gray)
                            .bold()
                    }
                
                if !isSignIn {
                    // Username field only for sign up
                    TextField("Username", text: $userName) // Should be a separate state variable if needed
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .textFieldStyle(.plain)
                        .frame(width: 350, height: 50)
                        .background(RoundedRectangle(cornerRadius: 25.0).fill(Color.white).frame(width: 380, height: 50))
                        .placeholder(when: userName.isEmpty) {
                            Text("Username")
                                .foregroundColor(.gray)
                                .bold()
                        }
                }
                
                SecureField("Password", text: $password)
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(RoundedRectangle(cornerRadius: 25.0).fill(Color.white).frame(width: 380, height: 50))
                    .frame(width: 350, height: 50)
                    .placeholder(when: password.isEmpty) {
                        Text("Password").foregroundColor(.gray).bold()
                    }
                
                if isSignIn {
                    Button(action: login) {
                        Text("Sign In")
                            .bold()
                            .font(.system(size: 18, weight: .light, design: .rounded))
                            .frame(width: 200, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.linearGradient(colors: [.blue, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)))
                            .foregroundColor(.white)
                    }
                } else {
                    Button(action: signup) {
                        Text("Sign Up")
                            .bold()
                            .font(.system(size: 18, weight: .light, design: .rounded))
                            .frame(width: 200, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.linearGradient(colors: [.blue, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)))
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    // Toggle the state between sign in and sign up
                    isSignIn.toggle()
                }) {
                    Text(isSignIn ? "Need an account? Sign up here" : "Already have an account? Login here")
                        .bold()
                        .font(.system(size: 14, weight: .light, design: .rounded))
                        .foregroundColor(.white)
                        .underline(color: .white)
                }
                .padding(.top)
                .offset(y: 100)
            }
            .frame(width: 350)
        }
        .ignoresSafeArea()
    }
    
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                userLoggedIn = true
            }
        }
    }
    
    func signup() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let user = authResult?.user {
                // Assuming you have a default profile URL or you can set it later
                let defaultProfileURL = "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
                
                // User details to be stored
                let userDetails: [String: Any] = [
                    "email": self.email,
                    "userName": self.userName, // Replace with actual user input if available
                    "uid": user.uid,
                    "profileURL": defaultProfileURL
                ]
                
                // Reference to Firestore database
                let db = Firestore.firestore()
                
                // Store user details in Firestore under "users" collection
                db.collection("users").document(user.uid).setData(userDetails) { error in
                    if let error = error {
                        print("Error storing user details: \(error.localizedDescription)")
                    } else {
                        print("User details stored successfully")
                        self.userLoggedIn = true
                    }
                }
            }
        }
    }

}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

