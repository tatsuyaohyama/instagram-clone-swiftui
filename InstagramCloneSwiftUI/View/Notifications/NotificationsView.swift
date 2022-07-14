//
//  NotificationsView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/30.
//

import SwiftUI

struct NotificationsView: View {
    
    @ObservedObject var viewModel = NotificationsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.notifications) { notification in
                        NotificationsRowView(viewModel: NotificationsRowViewModel(notification: notification))
                    }
                }
            }
            .navigationTitle("通知")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                viewModel.fetchNotifications()
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
