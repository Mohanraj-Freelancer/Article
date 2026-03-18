//
//  AuthRepository.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//


import AuthenticationServices

final class AuthRepository: AuthUseCase {
    
    private let keychain = KeychainManager.shared
    
    private let userKey = "apple_user_id"
    
    func loginWithApple(credential: ASAuthorizationAppleIDCredential) {
        let userID = credential.user
        keychain.save(key: userKey, value: userID)
    }
    
    func isUserLoggedIn() -> Bool {
        return keychain.read(key: userKey) != nil
    }
    
    func logout() {
        keychain.delete(key: userKey)
    }
}