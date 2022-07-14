//
//  TextCounterView.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/07/13.
//

import SwiftUI

struct TextCounterView: View {
    
    @Binding var text: String
    
    var body: some View {
        Text("\(text.count)")
            .foregroundColor(.gray)
    }
}

struct TextCounterView_Previews: PreviewProvider {
    static var previews: some View {
        TextCounterView(text: .constant(""))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
