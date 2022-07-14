//
//  FeedViewModel.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/30.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class FeedViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        Firestore.firestore().collection("posts").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }

            guard let documents = snapshot?.documents else { return }

            let posts = documents.compactMap({ try? $0.data(as: Post.self) })
            self.posts = posts
        }
    }
}
