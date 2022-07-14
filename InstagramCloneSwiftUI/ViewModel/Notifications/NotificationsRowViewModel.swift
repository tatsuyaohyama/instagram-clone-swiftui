//
//  NotificationsRowViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/13.
//

import SwiftUI
import Firebase

class NotificationsRowViewModel: ObservableObject {
    
    @Published var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
        fetchUser()
        fetchPost()
        checkFollow()
    }
    
    private func fetchUser() {
        UserService.fetchUser(uid: notification.uid) { user in
            self.notification.user = user
        }
    }
    
    private func fetchPost() {
        guard let postId = notification.postId else { return }
        Firestore.firestore().collection("posts").document(postId).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.notification.post = try? snapshot?.data(as: Post.self)
        }
    }
    
    func follow() {
        UserService.follow(uid: notification.uid) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            NotificationsViewModel.sendNotification(uid: self.notification.uid, type: .follow)
            self.notification.didFollow = true
        }
    }
    
    func unfollow() {
        UserService.unfollow(uid: notification.uid) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.notification.didFollow = false
        }
    }
    
    private func checkFollow() {
        UserService.checkFollow(uid: notification.uid) { didFollow in
            self.notification.didFollow = didFollow
        }
    }
}
