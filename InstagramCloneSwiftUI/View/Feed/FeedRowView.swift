//
//  FeedRowView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/30.
//

import SwiftUI
import SDWebImageSwiftUI
import PartialSheet

struct FeedRowView: View {
    
    @ObservedObject var viewModel: FeedRowViewModel
    @State private var showProfileView: Bool = false
    @State private var showMoreFunctionView: Bool = false
    @State private var showCommentsView: Bool = false
    
    var didLike: Bool {
        viewModel.post.didLike ?? false
    }
    
    init(viewModel: FeedRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if let user = viewModel.post.user {
                HStack {
                    WebImage(url: viewModel.post.ownerImageUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipped()
                        .modifier(CircleImageModifier())
                    
                    Text(viewModel.post.ownerUsername)
                        .font(.footnote)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        showMoreFunctionView.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
                .onTapGesture {
                    showProfileView.toggle()
                }
                .overlay(
                    NavigationLink(isActive: $showProfileView) {
                        ProfileView(viewModel: ProfileViewModel(user: user))
                            .navigationTitle(user.username)
                    } label: {
                        EmptyView()
                    }
                        .hidden()
                )
                .padding(.horizontal)
            }
            
            WebImage(url: viewModel.post.imageUrl)
                .resizable()
                .frame(height: 350)
                .clipped()
            
            HStack(spacing: 12) {
                Button {
                    didLike ? viewModel.dislike() : viewModel.like()
                } label: {
                    Image(systemName: didLike ? "heart.fill" : "heart")
                        .foregroundColor(didLike ? .red : .accentColor)
                }
                
                Button {
                    showCommentsView.toggle()
                } label: {
                    Image(systemName: "message")
                        .overlay(
                            NavigationLink(isActive: $showCommentsView, destination: {
                                CommentsView(viewModel: CommentsViewModel(post: viewModel.post))
                            }, label: {
                                EmptyView()
                            })
                            .hidden()
                        )
                }
                
                Button {
                    print("paperplane")
                } label: {
                    Image(systemName: "paperplane")
                }
                
                Spacer()
                
                Button {
                    print("bookmark")
                } label: {
                    Image(systemName: "bookmark")
                }
            }
            .font(.title2)
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("「いいね！」\(viewModel.post.likes)件")
                        .font(.callout)
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                Text(viewModel.post.ownerUsername)
                    .font(.callout)
                    .fontWeight(.semibold)
                +
                Text(viewModel.post.caption)
                    .font(.callout)
                
                if !viewModel.comments.isEmpty {
                    Text("コメント\(viewModel.comments.count)件を見る")
                        .foregroundColor(.gray)
                        .font(.callout)
                        .onTapGesture {
                            showCommentsView.toggle()
                        }
                        .overlay(
                            NavigationLink(isActive: $showCommentsView, destination: {
                                CommentsView(viewModel: CommentsViewModel(post: viewModel.post))
                            }, label: {
                                EmptyView()
                            })
                            .hidden()
                        )
                }
                
                Text(viewModel.post.postDateText)
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
            .partialSheet(isPresented: $showMoreFunctionView) {
                MoreFunctionView(post: $viewModel.post)
            }
            .padding(.horizontal)
        }
    }
}
