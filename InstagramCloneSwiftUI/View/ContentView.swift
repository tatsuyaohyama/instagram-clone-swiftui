//
//  ContentView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/28.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                SignInView()
            } else {
                if let user = viewModel.currentUser {
                    MainTabView(user: user)
                } else {
                    SignInView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel.shared)
    }
}
