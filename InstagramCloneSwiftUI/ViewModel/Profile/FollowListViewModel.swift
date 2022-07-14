//
//  FollowListViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/08.
//

import SwiftUI
import Firebase

class FollowListViewModel: ObservableObject {
    
    @Published var user: User
    @Published var following: [User] = []
    @Published var followers: [User] = []
    
    init(user: User) {
        self.user = user
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
            
            self.user.didFollow = true
            self.user.stats?.followers += 1
        }
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
                    var followingUser = user
                    followingUser.didFollow = true
                    self.following.append(followingUser)
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
