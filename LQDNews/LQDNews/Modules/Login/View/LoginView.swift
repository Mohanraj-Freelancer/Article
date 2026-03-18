//
//  LoginView.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//


import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var goToHome = false
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Login")
                .font(.largeTitle)
                .bold()
            
            SignInWithAppleButton(
                .signIn,
                onRequest: viewModel.handleAppleRequest,
                onCompletion: viewModel.handleAppleCompletion
            )
            .frame(height: 50)
            .cornerRadius(10)
            
            Button(action: {
                viewModel.isLoggedIn = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "forward.fill")
                        .foregroundColor(.gray)
                    Text("Skip")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 5)
            }
        }
        .padding()
    }
}
