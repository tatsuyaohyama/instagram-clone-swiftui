//
//  CommentInputView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/14.
//

import SwiftUI

struct CommentInputView: View {
    
    @Binding var comment: String
    var action: () -> Void
    
    var body: some View {
        HStack {
            TextField("コメントを追加...", text: $comment)
            
            Button(action: action) {
                Text("投稿する")
                    .fontWeight(.bold)
                    .foregroundColor(comment.isEmpty ? .blue.opacity(0.3) : .blue)
                    .disabled(comment.isEmpty ? true : false)
            }
        }
        .padding()
        .background(
            ZStack {
                Color.white
                    .cornerRadius(8)
                    .overlay(
                        Capsule()
                            .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                    )
            }
        )
    }
}

struct CommentInputView_Previews: PreviewProvider {
    static var previews: some View {
        CommentInputView(comment: .constant(""), action: {})
    }
}
