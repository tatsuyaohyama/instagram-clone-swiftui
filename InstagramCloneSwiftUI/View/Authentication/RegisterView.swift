//
//  RegisterView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/28.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var email: String = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password: String = ""
    @State private var selectedImage: UIImage?
    @State private var image: Image?
    @State private var showImagePicker: Bool = false
    @State private var showIndicator: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("instagram-text-logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 240, maxHeight: 80)
            
            Button {
                showImagePicker.toggle()
            } label: {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .modifier(CircleImageModifier())
                } else {
                    Image(systemName: "camera")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .frame(width: 150, height: 150)
                        .modifier(CircleImageModifier())
                }
            }
            .padding(.bottom)
            
            CustomTextField(placeholder: "メールアドレス", text: $email)
                .padding(.vertical, 4)
            CustomTextField(placeholder: "ユーザーネーム", text: $username)
                .padding(.vertical, 4)
            CustomTextField(placeholder: "フルネーム", text: $fullname)
                .padding(.vertical, 4)
            CustomSecureTextField(placeholder: "パスワード", text: $password)
                .padding(.vertical, 4)
            
            Button {
                guard let selectedImage = selectedImage else { return }
                showIndicator = true
                viewModel.register(withEmail: email, password: password, username: username, fullname: fullname, profileImage: selectedImage) {
                    showIndicator = false
                }
            } label: {
                Text("登録")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 360, height: 50)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding()
            }
            .disabled(showIndicator)
            .modifier(LoadingModifier(isLoading: $showIndicator))
            
            Spacer()
            
            HStack {
                Text("すでにアカウントをお持ちの場合")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Button {
                    dismiss()
                } label: {
                    Text("ログイン")
                        .font(.footnote)
                }
            }
        }
        .padding()
        .onChange(of: selectedImage) { _ in
            loadImage()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AuthViewModel.shared)
    }
}
