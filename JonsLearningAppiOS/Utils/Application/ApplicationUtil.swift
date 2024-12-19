//
//  ApplicationUtil.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/18/24.
//

import SwiftUI

extension UIApplication {
    var currentScene: UIWindowScene? {
        return connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
    }

    var currentViewController: UIViewController? {
        guard let windowScene = currentScene else { return nil }
        return windowScene.windows.first?.rootViewController
    }
}
