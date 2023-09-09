//
//  SignInViewViewModel.swift
//  ToDoApp
//
//  Created by O'lmasbek on 08/09/23.
//

import Foundation


@MainActor
class SignInViewViewModel: ObservableObject {
    
    func isFormValid(email: String, password: String) -> Bool {
        guard email.isValidEmail(), password.count > 7 else {
            return false
        }
        return true
    }
    //MARK: - Registration
    func registerNewUserWithEmail(email: String, password: String) async throws -> AppUser {
        if isFormValid(email: email, password: password) {
            return try await AuthManager.shared.registerNewUserWithEmail(email: email, password: password)
        } else {
            print("registration form is invalid")
            throw NSError()
        }
    }
    //MARK: - Sign in
    func signInWithEmail(email: String, password: String) async throws -> AppUser {
        if isFormValid(email: email, password: password) {
            return try await AuthManager.shared.signInWithEmail(email: email, password: password)
        } else {
            print("sign in form is invalid")
            throw NSError()
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}
