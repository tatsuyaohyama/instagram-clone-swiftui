//
//  MoreFunctionView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/06.
//

import SwiftUI

struct MoreFunctionView: View {
    
    @Binding var post: Post
    @State private var didFollow: Bool
    
    init(post: Binding<Post>) {
        self._post = post
        self._didFollow = State(initialValue: _post.wrappedValue.user?.didFollow ?? false)
    }
    
    func follow() {
        guard let uid = post.user?.id else { return }
        
        UserService.follow(uid: uid) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
        
        self.post.user?.didFollow = true
        didFollow = true
    }
    
    func unfollow() {
        guard let uid = post.user?.id else { return }
        
        UserService.unfollow(uid: uid) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.post.user?.didFollow = false
            didFollow = false
        }
    }
    
    var body: some View {
        VStack {
            Button {
                didFollow ? unfollow() : follow()
            } label: {
                Text(didFollow ? "フォローをやめる" : "フォローする")
                    .padding()
                    .foregroundColor(.accentColor)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
