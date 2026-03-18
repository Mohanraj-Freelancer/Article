//
//  OfflinePageView.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//

import SwiftUI

struct OfflinePageView: View {
    var action: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            // 📡 Offline Content
            VStack(spacing: 20) {
                
                Spacer()
                
                // WiFi Icon
                Image(systemName: "wifi.slash")
                    .font(.system(size: 70))
                    .foregroundColor(.black.opacity(0.8))
                
                // Title
                Text("You’re offline")
                    .font(.system(size: 22, weight: .semibold))
                
                // Subtitle
                Text("Please connect to the internet and try again.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                // Retry Button
                Button(action: {
                    action()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.gray)
                        Text("Retry")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 5)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray6))
        }
        .ignoresSafeArea(edges: .top)
    }
}


#Preview {
    OfflinePageView() {
        
    }
}
