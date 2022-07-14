//
//  CommentsRowView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/14.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentsRowView: View {
    
    @ObservedObject var viewModel: CommentsRowViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            if let user = viewModel.comment.user {
                WebImage(url: user.profileImageUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipped()
                    .modifier(CircleImageModifier())
                
                VStack(alignment: .leading) {
                    VStack {
                        Text(user.username)
                            .font(.footnote)
                            .fontWeight(.bold)
                        +
                        Text(viewModel.comment.comment)
                            .font(.footnote)
                    }
                    .padding(.bottom, 2)
                    
                    Text(viewModel.comment.timestampText)
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
                
                Spacer()
            }
        }
    }
}
