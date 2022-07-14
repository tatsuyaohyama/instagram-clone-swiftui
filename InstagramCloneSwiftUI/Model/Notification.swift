//
//  Notification.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/12.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Notification: Identifiable, Codable {
    @DocumentID var id: String?
    var postId: String?
    var timestamp: Timestamp
    var uid: String
    var type: NotificationType
    
    var post: Post?
    var user: User?
    var didFollow: Bool? = false
    
    var timestampText: String {
        let timeInterval: TimeInterval = timestamp.dateValue().timeIntervalSince(Date())
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.localizedString(fromTimeInterval: timeInterval)
    }
}

enum NotificationType: Int, Codable {
    case follow
    case comment
    case like
    
    var notificationMessage: String {
        switch self {
        case .follow:
            return "あなたをフォローしました。"
        case .comment:
            return "あなたの投稿にコメントしました。"
        case .like:
            return "あなたの投稿に「いいね」しました。"
        }
    }
}
