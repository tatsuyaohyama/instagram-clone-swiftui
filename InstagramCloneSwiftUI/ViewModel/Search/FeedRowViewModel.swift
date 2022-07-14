//
//  FeedRowViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/01.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class FeedRowViewModel: ObservableObject {
    
    @Published var post: Post
    @Published var comments: [Comment] = []
    
    init(post: Post) {
        self.post = post
        fetchUser()
        fetchComments()
        checkLike()
    }
    
    func fetchUser() {
        UserService.fetchUser(uid: post.ownerUid) { user in
            self.post.user = user
            self.post.ownerImageUrl = user.profileImageUrl
        }
    }
    
    func fetchComments() {
        PostService.fetchComments(post: post) { comments in
            self.comments = comments
        }
    }
    
    func like() {
        guard let postUid = post.id else { return }
        guard let userId = AuthViewModel.shared.userSession?.uid else { return }
        
        Firestore.firestore().collection("posts").document(postUid).collection("post-likes").document(userId)
            .setData([:]) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                Firestore.firestore().collection("users").document(userId).collection("user-likes").document(postUid)
                    .setData([:]) { error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        Firestore.firestore().collection("posts").document(postUid).updateData(["likes": self.post.likes + 1]) { error in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                            
                            NotificationsViewModel.sendNotification(uid: self.post.ownerUid, type: .like, post: self.post)
                            
                            self.post.likes += 1
                            self.post.didLike = true
                        }
                    }
            }
    }
    
    func dislike() {
        guard let postUid = post.id else { return }
        guard let userId = AuthViewModel.shared.userSession?.uid else { return }
        
        Firestore.firestore().collection("posts").document(postUid).collection("post-likes").document(userId)
            .delete { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                Firestore.firestore().collection("users").document(userId).collection("user-likes").document(postUid)
                    .delete { error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        Firestore.firestore().collection("posts").document(postUid).updateData(["likes": self.post.likes - 1]) { error in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                            
                            self.post.likes -= 1
                            self.post.didLike = false
                        }
                    }
            }
    }
    
    func checkLike() {
        guard let postUid = post.id else { return }
        guard let userId = AuthViewModel.shared.userSession?.uid else { return }
        
        Firestore.firestore().collection("posts").document(postUid).collection("post-likes").document(userId).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let didLike = snapshot?.exists else { return }
            self.post.didLike = didLike
        }
    }
}
