//
//  SearchViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/02.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    
    @Published var users: [User] = []
    
    init() {
        fetchUsers()
    }
    
    func filteredUsers(searchText: String) -> [User] {
        let lowercasedText = searchText.lowercased()
        
        return users.filter({ $0.username.lowercased().contains(lowercasedText) ||
            $0.fullname.lowercased().contains(lowercasedText)
        })
    }
    
    func fetchUsers() {
        UserService.fetchAllUsers { users in
            self.users = users
        }
    }
}
