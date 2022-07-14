//
//  UploadPost.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/30.
//

import SwiftUI

struct UploadPostView: View {
    
    @State private var caption: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            headerView
            
            HStack(spacing: 12) {
                photoView
                captionView
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        UploadPostView()
    }
}

extension UploadPostView {
    var headerView: some View {
        VStack {
            HStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                Spacer()
                
                Text("新規投稿")
                    .frame(minWidth: 0, maxWidth: .infinity)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button {
                        guard let image = selectedImage else { return }
                        PostService.uploadPost(image: image, caption: caption)
                        dismiss()
                    } label: {
                        Text("シェア")
                            .foregroundColor(.blue)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            
            Divider()
        }
        .padding()
    }
    
    var photoView: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 100)
                    .clipped()
                    .onTapGesture {
                        showImagePicker.toggle()
                    }
            } else {
                Image(systemName: "plus")
                    .frame(width: 80, height: 100)
                    .border(.gray.opacity(0.3), width: 1)
                    .onTapGesture {
                        showImagePicker.toggle()
                    }
            }
            Spacer()
        }
    }
    
    var captionView: some View {
        VStack {
            TextEditor(text: $caption)
                .frame(maxHeight: 100)
            TextCounterView(text: $caption)
                .frame(maxWidth: .infinity, alignment: .trailing)
            Spacer()
        }
    }
}
