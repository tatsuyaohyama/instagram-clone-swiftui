//
//  FollowButtonView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/13.
//

import SwiftUI

struct FollowButtonView: View {
    
    @Binding var didFollow: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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

struct FollowButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FollowButtonView(didFollow: .constant(false), action: {})
    }
}
