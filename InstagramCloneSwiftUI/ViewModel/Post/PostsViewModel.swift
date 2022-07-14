//
//  PostsViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/06.
//

import Foundation

class PostsViewModel: ObservableObject {
    
    @Published var user: User
    @Published var post: Post
    @Published var posts: [Post] = []
    
    init(user: User, post: Post) {
        self.user = user
        self.post = post
        fetchPosts()
    }
    
    func fetchPosts() {
        guard let uid = user.id else { return }
        PostService.fetchPosts(uid: uid) { posts in
            self.posts = posts
        }
    }
}
