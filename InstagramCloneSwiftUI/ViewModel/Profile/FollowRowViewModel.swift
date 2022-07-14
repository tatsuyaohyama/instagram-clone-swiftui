//
//  FollowRowViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/08.
//

import Foundation

class FollowRowViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
        checkFollow()
    }
    
    private func checkFollow() {
        guard !user.isCurrentUser else { return }
        guard let uid = user.id else { return }
        
        UserService.checkFollow(uid: uid) { didFollow in
            self.user.didFollow = didFollow
        }
    }
}
