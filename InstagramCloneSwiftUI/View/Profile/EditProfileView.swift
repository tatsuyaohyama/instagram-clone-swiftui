//
//  EditProfileView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/04.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditProfileView: View {
    
    @Binding var user: User
    @ObservedObject var viewModel: EditProfileViewModel
    
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var fullname: String
    @State private var username: String
    @State private var bio: String
    @Environment(\.dismiss) var dismiss
    
    init(user: Binding<User>) {
        self._user = user
        self._fullname = State(initialValue: _user.fullname.wrappedValue)
        self._username = State(initialValue: _user.username.wrappedValue)
        self._bio = State(initialValue: _user.bio.wrappedValue ?? "")
        viewModel = EditProfileViewModel(user: _user.wrappedValue)
        selectedImage = UIImage(named: _user.profileImageUrl.wrappedValue.absoluteString)
    }
    
    var body: some View {
        VStack {
            headerView
            
            Button {
                showImagePicker.toggle()
            } label: {
                VStack {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipped()
                            .modifier(CircleImageModifier())
                    } else {
                        WebImage(url: user.profileImageUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipped()
                            .modifier(CircleImageModifier())
                    }
                    
                    Text("プロフィール写真を変更")
                        .font(.subheadline)
                }
                .foregroundColor(.blue)
            }
            
            Divider()
            
            VStack(alignment: .leading) {
                    HStack {
                        Text("名前")
                            .font(.system(size: 16))
                            .frame(maxWidth: 80, maxHeight: 40, alignment: .leading)
                        VStack(alignment: .leading) {
                            TextEditor(text: $fullname)
                                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                
                HStack {
                    Text("ユーザーネーム")
                        .font(.system(size: 16))
                        .frame(maxWidth: 80, maxHeight: 40, alignment: .leading)
                    VStack(alignment: .leading) {
                        TextEditor(text: $username)
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                        Divider()
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("自己紹介")
                        .font(.system(size: 16))
                        .frame(maxWidth: 80, maxHeight: 40, alignment: .leading)
                    VStack(alignment: .leading) {
                        TextEditor(text: $bio)
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                    }
                }
                .padding(.horizontal)
            }
            
            Divider()
            
            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .onReceive(viewModel.$isComplete) { complete in
            if complete {
                self.user.fullname = viewModel.user.fullname
                self.user.username = viewModel.user.username
                self.user.profileImageUrl = viewModel.user.profileImageUrl
                self.user.bio = viewModel.user.bio
                dismiss()
            }
        }
    }
}

extension EditProfileView {
    var headerView: some View {
        VStack {
            ZStack {
                HStack(spacing: 0) {
                    Button {
                        dismiss()
                    } label: {
                        Text("キャンセル")
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.saveProfile(profileImage: selectedImage, fullname: fullname, username: username, bio: bio)
                    } label: {
                        Text("完了")
                            .foregroundColor(.blue)
                    }
                }
                
                HStack(alignment: .center) {
                    Text("プロフィールを編集")
                        .fontWeight(.bold)
                }
            }
            
            Divider()
        }
        .padding()
    }
}
