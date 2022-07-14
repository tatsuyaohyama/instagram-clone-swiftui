//
//  Modifiers.swift
//  InstagramCloneSwiftUI
//
//  Created by tatsuya ohyama on 2022/06/29.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if isLoading {
                content
                    .opacity(0.3)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            } else {
                content
            }
        }
        .scaledToFit()
    }
}

struct CircleImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color(uiColor: .systemGray3), lineWidth: 1)
            )
    }
}

struct RoundBlueButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .background(Color.blue)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(UIColor.systemGray5), lineWidth: 1)
            )
    }
}

struct RoundButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

struct RefreshableModifier: ViewModifier {
    let action: @Sendable () async -> Void

    func body(content: Content) -> some View {
        List {
            HStack {
                Spacer()
                content
                Spacer()
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
        .refreshable(action: action)
        .listStyle(PlainListStyle())
    }
}

extension ScrollView {
    func refreshable(action: @escaping @Sendable () async -> Void) -> some View {
        modifier(RefreshableModifier(action: action))
    }
}
