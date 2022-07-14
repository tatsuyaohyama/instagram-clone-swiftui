//
//  CommentsViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/14.
//

import SwiftUI
import Firebase

class CommentsViewModel: ObservableObject {
    
    let post: Post
    @Published var comments: [Comment] = []
    
    init(post: Post) {
        self.post = post
        fetchComments()
    }
    
    func uploadComment(comment: String) {
        guard let postId = post.id else { return }
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        
        let data: [String: Any] = [
            "comment": comment,
            "postOwnerId": post.ownerUid,
            "timestamp": Timestamp(date: Date()),
            "uid": uid
        ]
        
        Firestore.firestore().collection("posts").document(postId).collection("post-comments").addDocument(data: data) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            NotificationsViewModel.sendNotification(uid: self.post.ownerUid, type: .comment, post: self.post)
        }
    }
    
    func fetchComments() {
        PostService.fetchComments(post: post) { comments in
            self.comments = comments
        }
    }
}
