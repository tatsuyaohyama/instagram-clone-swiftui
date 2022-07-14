//
//  EditProfileViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/04.
//

import SwiftUI
import Firebase

class EditProfileViewModel: ObservableObject {
    
    var user: User
    @Published var isComplete: Bool = false
    
    init(user: User) {
        self.user = user
    }
    
    func updateProfileImage(image: UIImage?, completionHandler: @escaping (String?) -> Void) {
        if let image = image {
            ImageUploader.uploadImage(image: image, type: .profile) { imageUrl in
                completionHandler(imageUrl)
            }
        } else {
            completionHandler(nil)
        }
    }
    
    func saveProfile(profileImage: UIImage?, fullname: String, username: String, bio: String) {
        guard let uid = user.id else { return }
        
        updateProfileImage(image: profileImage) { imageUrl in
            var data = [
                "username": username,
                "fullname": fullname,
                "bio": bio
            ]
            
            if let imageUrl = imageUrl {
                data["profileImageUrl"] = imageUrl
            }
            
            Firestore.firestore().collection("users").document(uid).updateData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                self.user.fullname = fullname
                self.user.username = username
                if let imageUrl = imageUrl {
                    self.user.profileImageUrl = URL(string: imageUrl)!
                }
                self.user.bio = bio
                self.isComplete = true
            }
        }
    }
}
