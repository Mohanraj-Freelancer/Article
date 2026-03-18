//
//  LoginViewModel.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//


import SwiftUI
import AuthenticationServices
import Combine

final class LoginViewModel: NSObject, ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase = AuthRepository()) {
        self.authUseCase = authUseCase
        self.isLoggedIn = authUseCase.isUserLoggedIn()
    }
    
    // MARK: - Apple Request
    func handleAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    // MARK: - Apple Completion
    func handleAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                
                authUseCase.loginWithApple(credential: credential)
                isLoggedIn = true
                
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    func checkAppleCredentialState() {
        
        guard let userID = KeychainManager.shared.read(key: "apple_user_id") else {
            isLoggedIn = false
            return
        }
        
        let provider = ASAuthorizationAppleIDProvider()
        
        provider.getCredentialState(forUserID: userID) { state, error in
            DispatchQueue.main.async {
                switch state {
                case .authorized:
                    print("✅ User still authorized")
                    self.isLoggedIn = true
                    
                case .revoked, .notFound:
                    print("❌ Session invalid → logout")
                    self.logout()
                    
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Logout
    func logout() {
        authUseCase.logout()
        isLoggedIn = false
    }
}
