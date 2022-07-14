//
//  SearchRowView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/02.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchRowView: View {
    
    let user: User
    
    var body: some View {
        HStack {
            WebImage(url: user.profileImageUrl)
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipped()
                .modifier(CircleImageModifier())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.username)
                    .fontWeight(.bold)
                Text(user.fullname)
                    .foregroundColor(.gray)
            }
            .font(.footnote)
            
            Spacer()
        }
    }
}
