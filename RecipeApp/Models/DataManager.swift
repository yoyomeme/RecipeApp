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
    
    @Published var currentUser: User?
    @Published var recipes: [Recipe] = []
    private var imageCache = NSCache<NSString, UIImage>()//use for pre load images for faster loading
    
    private let db = Firestore.firestore()
    
    init() {
        
        fetchCurrentUser { updatedUsers in
            self.currentUser = updatedUsers
            
            self.fetchRecipes() // load images for faster image loading time
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
        guard let selectedImage = selectedImage else {
            completion(false, NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No image selected."]))
            return
        }
        
        // Calculate the target size and resize the image
        let originalSize = selectedImage.size
        let targetSize = calculateTargetSize(for: originalSize)
        guard let resizedImage = resizeImage(selectedImage, targetSize: targetSize) else {
            completion(false, NSError(domain: "AppErrorDomain", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to resize image."]))
            return
        }
        
        // Convert the resized image to JPEG data
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.75) else {
            completion(false, NSError(domain: "AppErrorDomain", code: -3, userInfo: [NSLocalizedDescriptionKey: "Image data could not be converted."]))
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
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = true // Set to false if the image has transparency
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: rendererFormat)
        
        let resizedImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return resizedImage
    }
    
    func calculateTargetSize(for originalSize: CGSize, maxWidth: CGFloat = 200, maxHeight: CGFloat = 200) -> CGSize {
        let widthRatio = maxWidth / originalSize.width
        let heightRatio = maxHeight / originalSize.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        let targetWidth = originalSize.width * scaleFactor
        let targetHeight = originalSize.height * scaleFactor
        
        return CGSize(width: targetWidth, height: targetHeight)
    }
    
    // Function to fetch recipes from Firestore
    func fetchRecipes() {
        db.collection("recipes").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting recipes: \(error.localizedDescription)")
            } else {
                if let querySnapshot = querySnapshot {
                    self.recipes = querySnapshot.documents.compactMap { document -> Recipe? in
                        // Attempt to convert the document into a Recipe object
                        try? document.data(as: Recipe.self)
                    }
                    // After fetching recipes, preload images
                    self.preloadImages()
                }
            }
        }
    }
    
    // Function to preload images for recipes
    private func preloadImages() {
        for recipe in recipes {
            guard let url = URL(string: recipe.imageUrl) else { continue }
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: recipe.imageUrl as NSString)
                }
            }
            task.resume()
        }
    }
    
    // Function to get a cached image
    func cachedImage(for imageUrl: String) -> UIImage? {
        return imageCache.object(forKey: imageUrl as NSString)
    }
    
    func deleteRecipe(withId id: String, completion: @escaping (Bool) -> Void) {
        db.collection("recipes").document(id).delete { error in
            if let error = error {
                print("Error deleting recipe: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Recipe successfully deleted")
                DispatchQueue.main.async {
                    // Remove the recipe from the local array
                    self.recipes.removeAll { $0.id == id }
                    completion(true)
                }
            }
        }
    }
    
}//end of code
