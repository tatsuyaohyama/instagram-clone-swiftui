//
//  FollowListView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/07.
//

import SwiftUI

struct FollowListView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    @State private var selection: Int
    @State private var showProfileView: Bool = false
    
    init(viewModel: ProfileViewModel, selection: Int) {
        self.viewModel = viewModel
        self.selection = selection
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("フォロワー")
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            selection = 0
                        }
                    }
                Text("フォロー中")
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            selection = 1
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .overlay(
                ZStack {
                    Divider()
                    VStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: UIScreen.main.bounds.width / 2, height: 1, alignment: .leading)
                            .offset(x: selection == 0 ? 0 : UIScreen.main.bounds.width / 2)
                            .animation(.easeInOut, value: selection)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                , alignment: .bottom
            )
            
            TabView(selection: $selection) {
                followersView
                    .tag(0)
                followingView
                    .tag(1)
            }
            .padding(.horizontal)
            .tabViewStyle(.page)
        }
    }
}

extension FollowListView {
    var followingView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.following) { item in
                    FollowRowView(viewModel: viewModel, user: item)
                        .onTapGesture {
                            showProfileView.toggle()
                        }
                        .overlay(
                            NavigationLink(isActive: $showProfileView, destination: {
                                ProfileView(viewModel: ProfileViewModel(user: item))
                            }, label: {
                                EmptyView()
                            })
                            .hidden()
                        )
                }
            }
        }
        .refreshable {
            await viewModel.fetchFollowing()
        }
    }
    
    var followersView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.followers) { item in
                    FollowRowView(viewModel: viewModel, user: item)
                        .onTapGesture {
                            showProfileView.toggle()
                        }
                        .overlay(
                            NavigationLink(isActive: $showProfileView, destination: {
                                ProfileView(viewModel: ProfileViewModel(user: item))
                            }, label: {
                                EmptyView()
                            })
                            .hidden()
                        )
                }
            }
        }
        .refreshable {
            await viewModel.fetchFollowers()
        }
    }
}
