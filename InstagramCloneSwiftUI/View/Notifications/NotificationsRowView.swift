//
//  NotificationsRowView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/13.
//

import SwiftUI
import SDWebImageSwiftUI

struct NotificationsRowView: View {
    
    @ObservedObject var viewModel: NotificationsRowViewModel
    @State private var showProfileView: Bool = false
    
    init(viewModel: NotificationsRowViewModel) {
        self.viewModel = viewModel
    }
    
    var didFollow: Bool {
        viewModel.notification.didFollow ?? false
    }
    
    var body: some View {
        HStack {
            if let user = viewModel.notification.user {
                WebImage(url: user.profileImageUrl)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 48, height: 48)
                    .modifier(CircleImageModifier())
                    .onTapGesture {
                        showProfileView.toggle()
                    }
                    .overlay(
                        NavigationLink(isActive: $showProfileView, destination: {
                            ProfileView(viewModel: ProfileViewModel(user: user))
                        }, label: {
                            EmptyView()
                        })
                        .hidden()
                    )
                
                VStack(alignment: .leading) {
                    Text(viewModel.notification.type.notificationMessage)
                        .font(.callout)
                        .fontWeight(.semibold)
                    HStack {
                        Text(user.username)
                        Spacer()
                        Text(viewModel.notification.timestampText)
                    }
                    .foregroundColor(.gray)
                    .font(.footnote)
                }
                
                Spacer()
                
                if viewModel.notification.type == .follow {
                    Button {
                        didFollow ? viewModel.unfollow() : viewModel.follow()
                    } label: {
                        Text(didFollow ? "フォロー中" : "フォローする")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxHeight: 40)
                            .foregroundColor(didFollow ? .black : .white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                            )
                            .background(RoundedRectangle(cornerRadius: 4).fill(didFollow ? Color.white : Color.blue))
                    }
                } else {
                    if let post = viewModel.notification.post {
                        NavigationLink {
                            ScrollView {
                                FeedRowView(viewModel: FeedRowViewModel(post: post))
                            }
                        } label: {
                            WebImage(url: post.imageUrl)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 48, height: 48)
                                .clipShape(Rectangle())
                        }
                    }
                }
            }
        }
        .padding()
    }
}
