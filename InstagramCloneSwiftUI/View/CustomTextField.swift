//
//  CustomTextField.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/28.
//

import SwiftUI

struct CustomTextField: View {
    
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
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
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(placeholder: "メールアドレス", text: .constant(""))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
