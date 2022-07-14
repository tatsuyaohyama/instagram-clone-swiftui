//
//  CustomSecureTextField.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/29.
//

import SwiftUI

struct CustomSecureTextField: View {
    
    @FocusState var focused: focusedField?
    let placeholder: String
    @Binding var text: String
    @State private var showText: Bool = false
    
    var body: some View {
        HStack {
            ZStack {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.alphabet)
                    .padding()
                    .opacity(showText ? 1 : 0)
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .opacity(showText ? 0 : 1)
            }
            Image(systemName: showText ? "eye" : "eye.slash")
                .foregroundColor(showText ? .blue : .black)
                .padding()
                .onTapGesture {
                    showText.toggle()
                }
        }
        .background(
            ZStack {
                Color(UIColor.init(white: 0.9, alpha: 0.3))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                    )
            }
        )
    }
    
    enum focusedField {
        case secure, unSecure
    }
}

struct CustomSecureTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomSecureTextField(placeholder: "パスワード", text: .constant(""))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
