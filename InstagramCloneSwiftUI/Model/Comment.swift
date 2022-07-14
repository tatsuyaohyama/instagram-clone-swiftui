//
//  Comment.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/14.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    var comment: String
    var postOwnerId: String
    var timestamp: Timestamp
    var uid: String
    
    var user: User?
    
    var timestampText: String {
        let timeInterval: TimeInterval = timestamp.dateValue().timeIntervalSince(Date())
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.localizedString(fromTimeInterval: timeInterval)
    }
}
