//
//  PostsView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/06.
//

import SwiftUI

struct PostsView: View {
    
    @StateObject var viewModel: PostsViewModel
    @State private var isFirstAppear: Bool = true
    
    var body: some View {
        ScrollViewReader { proxy in
            List(viewModel.posts) {
                FeedRowView(viewModel: FeedRowViewModel(post: $0))
                    .padding(.vertical, 14)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .id($0.id)
                    .onAppear {
                        if isFirstAppear {
                            proxy.scrollTo(viewModel.post.id, anchor: .top)
                            isFirstAppear = false
                        }
                    }
            }
        }
        .buttonStyle(.plain)
        .navigationTitle("投稿")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
    }
}

//struct PostsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostsView(viewModel: PostsViewModel(user: AuthViewModel.shared.currentUser!, post: ))
//    }
//}
