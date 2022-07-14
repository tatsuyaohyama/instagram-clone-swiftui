//
//  MainTabView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/30.
//

import SwiftUI

enum Tab: String {
    case feed, search, post, notifications, profile
}

struct MainTabView: View {
    
    let user: User
    
    @State private var selectedTab: Tab = .feed
    @State private var showAlertLogout: Bool = false
    
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "house")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            
            PostView()
                .tabItem {
                    Image(systemName: "plus.app.fill")
                }
            
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                }
            
            NavigationView {
                ProfileView(viewModel: ProfileViewModel(user: user))
                    .navigationTitle(user.username)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showAlertLogout.toggle()
                            } label: {
                                Text("ログアウト")
                            }
                            
                        }
                    }
            }
            .tabItem {
                Image(systemName: "person.circle")
            }
        }
        .alert("ログアウトしますか？", isPresented: $showAlertLogout) {
            Button {
                AuthViewModel.shared.logout()
            } label: {
                Text("はい")
            }
            
            Button(action: {}) {
                Text("いいえ")
            }
        }
    }
}
