//
//  PostService.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/30.
//

import SwiftUI
import Firebase

struct PostService {
    static func uploadPost(image: UIImage, caption: String) {
        guard let currentUser = AuthViewModel.shared.currentUser else { return }
        
        ImageUploader.uploadImage(image: image, type: .post) { imageUrl in
            
            guard let ownerUid = currentUser.id else { return }
            
            let data: [String: Any] = [
                "caption": caption,
                "imageUrl": imageUrl,
                "likes": 0,
                "ownerUid": ownerUid,
                "ownerUsername": currentUser.username,
                "timestamp": Timestamp(date: Date())
            ]
            
            Firestore.firestore().collection("posts").addDocument(data: data) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    static func fetchPosts(uid: String, completionHandler: @escaping (([Post]) -> Void)) {
        Firestore.firestore().collection("posts").whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.compactMap({ try? $0.data(as: Post.self) })
            completionHandler(posts)
        }
    }
    
    static func fetchComments(post: Post, completionHandler: @escaping (([Comment]) -> Void)) {
        guard let postId = post.id else { return }
        
        Firestore.firestore().collection("posts").document(postId).collection("post-comments").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            
            let comments = documents.compactMap({ try? $0.document.data(as: Comment.self) })
            completionHandler(comments)
        }
    }
}
