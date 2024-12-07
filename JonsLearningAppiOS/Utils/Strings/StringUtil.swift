//
//  StringUtil.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/5/24.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        let isValidEmail = emailPredicate.evaluate(with: self)
        return isValidEmail
    }
}
