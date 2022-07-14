//
//  ImageUploader.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/29.
//

import SwiftUI
import FirebaseStorage

enum Upload: String {
    case profile = "profile_images/"
    case post = "post_images/"
    
    var storageReference: StorageReference {
        let filename = UUID().uuidString
        switch self {
        case .profile:
            return Storage.storage().reference().child("profile_images/\(filename)")
        case .post:
            return Storage.storage().reference().child("post_images/\(filename)")
        }
    }
}

struct ImageUploader {
    static func uploadImage(image: UIImage, type: Upload, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else { return }
        let storageRef = type.storageReference
        
        storageRef.putData(imageData) { metadata, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
