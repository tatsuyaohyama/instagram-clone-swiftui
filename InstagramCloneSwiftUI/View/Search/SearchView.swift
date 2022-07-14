//
//  SearchView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/30.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var viewModel = SearchViewModel()
    @State private var searchText: String = ""
    
    var displayUsers: [User] {
        searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText: searchText)
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(displayUsers) { user in
                        NavigationLink {
                            ProfileView(viewModel: ProfileViewModel(user: user))
                                .navigationTitle(user.username)
                        } label: {
                            SearchRowView(user: user)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.fetchUsers()
            }
            .navigationTitle("検索")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}
