//
//  FollowRowView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/07.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowRowView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @State var user: User
    
    var didFollow: Bool {
        user.didFollow ?? false
    }
    
    func follow() {
        guard let uid = user.id else { return }
        
        UserService.follow(uid: uid) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            NotificationsViewModel.sendNotification(uid: uid, type: .follow)
            self.user.didFollow = true
            if viewModel.user.isCurrentUser {
                self.viewModel.user.stats?.following += 1
            } else {
                self.viewModel.user.stats?.followers += 1
            }
        }
    }
    
    func unfollow() {
        guard let uid = user.id else { return }
        
        UserService.unfollow(uid: uid) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.user.didFollow = false
            if viewModel.user.isCurrentUser {
                self.viewModel.user.stats?.following -= 1
            } else {
                self.viewModel.user.stats?.followers -= 1
            }
        }
    }
    
    var body: some View {
        HStack {
            WebImage(url: user.profileImageUrl)
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 48, height: 48)
                .modifier(CircleImageModifier())
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .fontWeight(.bold)
                Text(user.fullname)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if !user.isCurrentUser {
                Button {
                    didFollow ? unfollow() : follow()
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
            }
        }
    }
}
