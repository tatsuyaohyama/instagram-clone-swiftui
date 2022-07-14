//
//  PostView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/30.
//

import SwiftUI

struct PostView: View {
    
    @State private var showUploadPost: Bool = false
    
    var body: some View {
        Button {
            showUploadPost.toggle()
        } label: {
            VStack {
                Image(systemName: "plus.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                Text("投稿する")
                    .font(.title2)
            }
        }
        .sheet(isPresented: $showUploadPost) {
            UploadPostView()
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
