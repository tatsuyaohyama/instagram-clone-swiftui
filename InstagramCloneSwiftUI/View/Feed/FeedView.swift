//
//  FeedView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/30.
//

import SwiftUI

struct FeedView: View {
    
    @StateObject var viewModel = FeedViewModel()
    @State var showProfileView: Bool = false
    
    var body: some View {
        NavigationView {
            List(viewModel.posts) {
                FeedRowView(viewModel: FeedRowViewModel(post: $0))
                    .padding(.vertical, 14)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }
            .buttonStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("instagram-text-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                }
            }
            .refreshable {
                viewModel.fetchPosts()
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
