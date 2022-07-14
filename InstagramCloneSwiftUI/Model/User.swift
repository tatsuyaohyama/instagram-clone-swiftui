//
//  User.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/29.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    var email: String
    var username: String
    var fullname: String
    var profileImageUrl: URL
    @DocumentID var id: String?
    var stats: UserStats?
    var bio: String?
    var didFollow: Bool? = false
    
    var isCurrentUser: Bool {
        AuthViewModel.shared.userSession?.uid == id
    }
}

struct UserStats: Codable {
    var following: Int
    var followers: Int
    var posts: Int
}
