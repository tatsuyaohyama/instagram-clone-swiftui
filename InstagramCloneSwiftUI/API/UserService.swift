//
//  UserService.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/01.
//

import SwiftUI
import Firebase

struct UserService {
    static func fetchUser(uid: String, completionHandler: @escaping (User) -> Void) {
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completionHandler(user)
        }
    }
    
    static func fetchAllUsers(completionHandler: @escaping ([User]) -> Void) {
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            let users = documents.compactMap({ try? $0.data(as: User.self) })
            completionHandler(users)
        }
    }
    
    static func follow(uid: String, completionHandler: ((Error?) -> Void)?) {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        
        Firestore.firestore().collection("following").document(currentUid).collection("user-following").document(uid).setData([:]) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            Firestore.firestore().collection("followers").document(uid)
                .collection("user-followers").document(currentUid).setData([:], completion: completionHandler)
        }
    }
    
    static func unfollow(uid: String, completionHandler: ((Error?) -> Void)?) {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        
        Firestore.firestore().collection("following").document(currentUid).collection("user-following").document(uid).delete { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            Firestore.firestore().collection("followers").document(uid)
                .collection("user-followers").document(currentUid).delete(completion: completionHandler)
        }
    }
    
    static func checkFollow(uid: String, completionHandler: @escaping ((Bool) -> Void)) {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        
        Firestore.firestore().collection("following").document(currentUid).collection("user-following").document(uid).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let didFollow = snapshot?.exists else { return }
            
            completionHandler(didFollow)
        }
    }
}
