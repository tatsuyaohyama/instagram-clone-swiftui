//
//  CommentsView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/14.
//

import SwiftUI

struct CommentsView: View {
    
    @State private var comment: String = ""
    @StateObject var viewModel: CommentsViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.comments) { comment in
                        CommentsRowView(viewModel: CommentsRowViewModel(comment: comment))
                            .padding(8)
                    }
                }
            }
            .refreshable {
                await viewModel.fetchComments()
            }
            
            Divider()
            
            CommentInputView(comment: $comment) {
                viewModel.uploadComment(comment: comment)
                comment = ""
            }
            .padding()
            .navigationTitle("コメント")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
