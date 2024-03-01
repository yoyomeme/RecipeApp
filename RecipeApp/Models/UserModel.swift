//
//  UserModel.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI
import Firebase

class UserModel: ObservableObject {
    @Published var users: [User] = []
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers() {
        users.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("User")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let email = data["email"] as? String ?? ""
                    let userName = data["userName"] as? String ?? ""
                    let uid = data["uid"] as? String ?? ""
                    let profileURL = data["profileURL"] as? String ?? ""
                    
                    let user = User(email: email, userName: userName, uid: uid, profileURL: profileURL)
                    self.users.append(user)
                }
            }
        }
        
    }
}
