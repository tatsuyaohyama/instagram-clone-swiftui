//
//  AuthViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/28.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    
    @Published var userSession: Firebase.User?
    @Published var currentUser: User?
    
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func login(withEmail email: String, password: String, completionHandler: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler()
                return
            }
            
            guard let user = result?.user else {
                completionHandler()
                return
            }
            
            self.userSession = user
            self.fetchUser()
            
            completionHandler()
        }
    }
    
    func register(withEmail email: String, password: String, username: String, fullname: String, profileImage: UIImage, completionHandler: @escaping () -> Void) {
        ImageUploader.uploadImage(image: profileImage, type: .profile) { imageUrl in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    completionHandler()
                    return
                }
                
                guard let user = result?.user else {
                    completionHandler()
                    return
                }
                
                let data = [
                    "email": email,
                    "username": username,
                    "fullname": fullname,
                    "profileImageUrl": imageUrl,
                    "uid": user.uid
                ]
                
                Firestore.firestore().collection("users").document(user.uid).setData(data) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        completionHandler()
                        return
                    }
                    
                    self.userSession = user
                    self.fetchUser()
                    
                    completionHandler()
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            userSession = nil
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
        UserService.fetchUser(uid: uid) { user in
            self.currentUser = user
        }
    }
}
