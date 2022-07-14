//
//  ProfilePostsView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/11.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfilePostsView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
//        VStack {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1)], spacing: 1) {
                ForEach(viewModel.posts) { post in
                    NavigationLink(destination: PostsView(viewModel: PostsViewModel(user: viewModel.user, post: post))) {
                        Color.white
                            .aspectRatio(1, contentMode: .fill)
                            .overlay(
                                WebImage(url: post.imageUrl)
                                    .resizable()
                                    .scaledToFill()
                            )
                            .clipped()
                    }
                }
            }
//        }
    }
}

//struct ProfilePostsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePostsView()
//    }
//}
