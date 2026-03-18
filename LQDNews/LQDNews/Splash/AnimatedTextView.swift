//
//  AnimatedTextView.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//


import SwiftUI

struct AnimatedTextView: View {
    
    var progress: CGFloat
    
    var body: some View {
        ZStack {
            
            // 🌈 Liquid Glass Background
            LinearGradient(
                colors: [
                    Color.cyan.opacity(0.20),
                    Color.white.opacity(0.08),
                    Color.blue.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 🪟 Glass Frost Layer
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            // ✨ Glow text (glass feel)
            Text("Article")
                .font(.system(size: 60, weight: .medium, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .white],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(progress)
                .shadow(color: .cyan.opacity(0.6), radius: 10)
            
            // 💡 Light tracing effect (improved)
            Text("Article")
                .font(.system(size: 60, weight: .medium, design: .rounded))
                .overlay(
                    GeometryReader { geo in
                        Rectangle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                LinearGradient(
                                    colors: [.white, .cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 2, lineCap: .round)
                            )
                    }
                )
                .foregroundColor(.clear)
        }
    }
}
