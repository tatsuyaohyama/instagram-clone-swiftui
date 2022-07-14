//
//  Post.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/30.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    let caption: String
    let imageUrl: URL
    var likes: Int
    let ownerUid: String
    let ownerUsername: String
    var ownerImageUrl: URL?
    let timestamp: Timestamp
    
    var user: User?
    var didLike: Bool? = false
    
    var postDateText: String {
        let timeInterval: TimeInterval = timestamp.dateValue().timeIntervalSince(Date())
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.localizedString(fromTimeInterval: timeInterval)
    }
}

let samplePost = Post(
    caption: "これはキャプションです",
    imageUrl: URL(string: "https://www.photock.jp/photo/middle/photo0000-0360.jpg")!,
    likes: 0,
    ownerUid: "",
    ownerUsername: "Tastsuya Ohyama",
    ownerImageUrl: URL(string: "https://www.photock.jp/photo/middle/photo0000-0360.jpg"),
    timestamp: Timestamp(date: Date())
)
