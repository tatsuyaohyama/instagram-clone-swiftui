//
//  NotificationsViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/12.
//

import SwiftUI
import Firebase

class NotificationsViewModel: ObservableObject {
    
    @Published var notifications: [Notification] = []
    
    init() {
        fetchNotifications()
    }
    
    func fetchNotifications() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        
        Firestore.firestore().collection("notifications").document(uid).collection("user-notifications")
            .order(by: "timestamp", descending: true).getDocuments { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                self.notifications = documents.compactMap({ try? $0.data(as: Notification.self) })
            }
    }
    
    static func sendNotification(uid: String, type: NotificationType, post: Post? = nil) {
        guard let user = AuthViewModel.shared.currentUser else { return }
        guard let currentUserId = user.id else { return }
        
        var data: [String: Any] = [
            "uid": currentUserId,
            "type": type.rawValue,
            "timestamp": Timestamp(date: Date())
        ]
        
        if let post = post, let postId = post.id {
            data["postId"] = postId
        }
        
        Firestore.firestore().collection("notifications").document(uid).collection("user-notifications")
            .addDocument(data: data) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
    }
}
