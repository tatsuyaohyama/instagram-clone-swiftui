//
//  ProfileViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/03.
//

import SwiftUI
import Firebase

class ProfileViewModel: ObservableObject {
    
    @Published var user: User
    @Published var posts: [Post] = []
    @Published var following: [User] = []
    @Published var followers: [User] = []
    
    init(user: User) {
        self.user = user
        updateProfile()
    }
    
    func updateProfile() {
        checkFollow()
        fetchStats()
        fetchPosts()
        fetchFollowing()
        fetchFollowers()
    }
    
    func follow() {
        guard let uid = user.id else { return }
        
        UserService.follow(uid: uid) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
        
        self.user.didFollow = true
        self.user.stats?.followers += 1
        NotificationsViewModel.sendNotification(uid: uid, type: .follow)
    }
    
    func unfollow() {
        guard let uid = user.id else { return }
        
        UserService.unfollow(uid: uid) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.user.didFollow = false
            self.user.stats?.followers -= 1
        }
    }
    
    func checkFollow() {
        guard !user.isCurrentUser else { return }
        guard let uid = user.id else { return }
        
        UserService.checkFollow(uid: uid) { didFollow in
            self.user.didFollow = didFollow
        }
    }
    
    func fetchStats() {
        guard let uid = user.id else { return }
        
        Firestore.firestore().collection("following").document(uid).collection("user-following").getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let following = snapshot?.documents.count else { return }
            
            Firestore.firestore().collection("followers").document(uid).collection("user-followers").getDocuments { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let followers = snapshot?.documents.count else { return }
                
                Firestore.firestore().collection("posts").whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    guard let posts = snapshot?.documents.count else { return }
                    self.user.stats = UserStats(following: following, followers: followers, posts: posts)
                }
            }
        }
    }
    
    func fetchPosts() {
        guard let uid = user.id else { return }
        PostService.fetchPosts(uid: uid) { posts in
            self.posts = posts
        }
    }
    
    func fetchFollowing() {
        guard let uid = user.id else { return }
        
        Firestore.firestore().collection("following").document(uid).collection("user-following").getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            self.following.removeAll()
            
            for document in documents {
                UserService.fetchUser(uid: document.documentID) { user in
                    if let uid = user.id {
                        UserService.checkFollow(uid: uid) { didFollow in
                            var user = user
                            user.didFollow = didFollow
                            self.following.append(user)
                        }
                    } else {
                        self.following.append(user)
                    }
                }
            }
        }
    }
    
    func fetchFollowers() {
        guard let uid = user.id else { return }
        
        Firestore.firestore().collection("followers").document(uid).collection("user-followers").getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            self.followers.removeAll()
            
            for document in documents {
                UserService.fetchUser(uid: document.documentID) { user in
                    if let uid = user.id {
                        UserService.checkFollow(uid: uid) { didFollow in
                            var user = user
                            user.didFollow = didFollow
                            self.followers.append(user)
                        }
                    } else {
                        self.followers.append(user)
                    }
                }
            }
        }
    }
}
