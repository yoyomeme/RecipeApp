//
//  DataManager.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import StoreKit
import FirebaseAuth
import FirebaseStorage

class DataManager: ObservableObject {
    
    //@Published var users: [User] = []
    @Published var currentUser: User?
    
    private let db = Firestore.firestore()
    
    init() {
        
        fetchCurrentUser { updatedUsers in
            self.currentUser = updatedUsers
        }
    }
    
    
    func refreshUsers() {
        fetchCurrentUser()
    }
    
    func fetchCurrentUser(completion: ((User?) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let currentUser = User(
                    email: data?["email"] as? String ?? "",
                    userName: data?["userName"] as? String ?? "",
                    uid: uid,
                    profileURL: data?["profileURL"] as? String ?? ""
                )
                DispatchQueue.main.async {
                    self.currentUser = currentUser
                    completion?(currentUser)
                }
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func updateUserDetails(name: String, email: String, profileURL: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        let userDocument = db.collection("users").document(uid)
        
        userDocument.updateData([
            "userName": name,
            "email": email,
            "profileURL": profileURL
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                // Optionally, refresh the currentUser data
                self.fetchCurrentUser()
            }
        }
    }
    
    
    // Function to upload image to Firebase Storage and save recipe details to Firestore
    func addRecipe(recipeName: String, ingredients: String, steps: String, recipeType: RecipeType?, selectedImage: UIImage?, completion: @escaping (Bool, Error?) -> Void) {
        // First, we upload the image to Firebase Storage
        guard let imageData = selectedImage?.jpegData(compressionQuality: 0.75) else {
            completion(false, NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Image data could not be converted."]))
            return
        }
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("recipeImages/\(imageName).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                completion(false, error)
                return
            }
            
            // After the image is uploaded, fetch its download URL
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(false, error)
                    return
                }
                
                // Now, we save the recipe details along with the image URL to Firestore
                let db = Firestore.firestore()
                let recipeData: [String: Any] = [
                    "name": recipeName,
                    "type": recipeType?.name ?? "",
                    "ingredients": ingredients,
                    "steps": steps,
                    "imageUrl": downloadURL.absoluteString
                ]
                
                db.collection("recipes").addDocument(data: recipeData) { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                }
            }
        }
    }

    
    
}//end of code
