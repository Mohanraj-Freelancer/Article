//
//  SplashView.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//


import SwiftUI

struct SplashView: View {
    
    @State private var progress: CGFloat = 0
    @State private var showMain = false
    @StateObject private var viewModel = LoginViewModel()
    var body: some View {
        ZStack {
            
            // ✅ Always-present Liquid Background (fixes black screen)
            LiquidBackgroundView()
                .ignoresSafeArea()
            
            // Content switch
            if showMain {
                if viewModel.isLoggedIn {
                    ArticleListView(loginViewModel: viewModel)
                        .transition(.opacity)
                } else {
                    LoginView(viewModel: viewModel)
                }
            } else {
                AnimatedTextView(progress: progress)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showMain)
        .onAppear {
            startAnimation()
            viewModel.checkAppleCredentialState()
        }
    }
    
    private func startAnimation() {
        // Text animation
        withAnimation(.easeInOut(duration: 2.5)) {
            progress = 1
        }
        
        // Navigate after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showMain = true
            }
        }
    }
}

struct LiquidBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.cyan.opacity(0.25),
                    Color.white.opacity(0.08),
                    Color.blue.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Rectangle()
                .fill(.ultraThinMaterial)
        }
    }
}
