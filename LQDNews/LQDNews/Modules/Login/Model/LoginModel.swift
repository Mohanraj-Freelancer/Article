//
//  LoginModel.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct AppError: Identifiable {
    let id = UUID()
    let message: String
}

protocol AuthUseCase {
    func loginWithApple(credential: ASAuthorizationAppleIDCredential)
    func isUserLoggedIn() -> Bool
    func logout()
}
