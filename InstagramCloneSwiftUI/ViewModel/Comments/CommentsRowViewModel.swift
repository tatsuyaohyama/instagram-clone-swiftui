//
//  CommentsRowViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/14.
//

import Foundation

class CommentsRowViewModel: ObservableObject {
    
    @Published var comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
        fetchUser()
    }
    
    private func fetchUser() {
        UserService.fetchUser(uid: comment.uid) { user in
            self.comment.user = user
        }
    }
}
