//
//  ProfileHeaderView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/11.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileHeaderView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showEditProfileView: Bool = false
    @State private var showFollowListView: Bool = false
    @State private var selection: Int = 0
    
    var didFollow: Bool {
        viewModel.user.didFollow ?? false
    }
    
    var posts: Int {
        viewModel.user.stats?.posts ?? 0
    }
    
    var following: Int {
        viewModel.user.stats?.following ?? 0
    }
    
    var followers: Int {
        viewModel.user.stats?.followers ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                WebImage(url: viewModel.user.profileImageUrl)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 100, height: 100)
                    .modifier(CircleImageModifier())
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Text("\(posts)")
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(posts == 0 ? .gray : .accentColor)
                        Text("投稿")
                            .font(.callout)
                    }
                    
                    Spacer()
                    
                    Button {
                        selection = 0
                        showFollowListView.toggle()
                    } label: {
                        VStack {
                            Text("\(followers)")
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundColor(followers == 0 ? .gray : .accentColor)
                            Text("フォロワー")
                                .font(.callout)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        selection = 1
                        showFollowListView.toggle()
                    } label: {
                        VStack {
                            Text("\(following)")
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundColor(following == 0 ? .gray : .accentColor)
                            Text("フォロー中")
                                .font(.callout)
                        }
                    }
                    
                    NavigationLink(isActive: $showFollowListView) {
                        FollowListView(viewModel: viewModel, selection: selection)
                    } label: {
                        EmptyView()
                    }

                }
            }
            
            VStack(alignment: .leading) {
                Text(viewModel.user.fullname)
                    .font(.body)
                    .fontWeight(.bold)
                Text(viewModel.user.bio ?? "")
                    .font(.body)
                    .lineLimit(nil)
            }
            
            if viewModel.user.isCurrentUser {
                HStack {
                    Button {
                        showEditProfileView.toggle()
                    } label: {
                        Text("プロフィールを編集")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                            )
                    }
                }
                .padding(.vertical, 12)
            } else {
                HStack {
                    Button {
                        didFollow ? viewModel.unfollow() : viewModel.follow()
                    } label: {
                        Text(didFollow ? "フォロー中" : "フォローする")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .foregroundColor(didFollow ? .black : .white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                            )
                            .background(RoundedRectangle(cornerRadius: 4).fill(didFollow ? Color.white : Color.blue))
                    }
                    
                    Button {
                        print("send message")
                    } label: {
                        Text("メッセージ")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                            )
                    }
                }
                .padding(.vertical, 12)
            }
        }
//        .padding(.horizontal)
        .sheet(isPresented: $showEditProfileView, content: {
            EditProfileView(user: $viewModel.user)
        })
    }
}

//struct ProfileHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileHeaderView()
//    }
//}
