//
//  NavigationState.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/5/25.
//

import SwiftUI

class NavigationState: ObservableObject {
    @Published var path = NavigationPath()
}
