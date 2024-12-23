//
//  NavigatableView.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/18/24.
//
import SwiftUI

struct NavigatableView<Content: View>: View {
    var title: String
    var popToRoot: Bool
    var content: Content
    
    init(title: String, popToRoot: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.popToRoot = popToRoot
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: title, popToRoot : popToRoot)
                .zIndex(2)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
    }
}

struct NavigatableView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatableView(title: "Home", popToRoot: false) {
            Color.red
        }
    }
}
