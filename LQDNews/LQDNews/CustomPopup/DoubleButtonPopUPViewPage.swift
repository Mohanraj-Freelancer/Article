//
//  DoubleButtonPopUPViewPage.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//


import SwiftUI


struct DoubleButtonPopUPViewPage: View {
    @Binding var isPresented: Bool
    @State private var offsetX: CGFloat = -UIScreen.main.bounds.width // Start offscreen (left)
    let horizontalPadding: CGFloat = 45 // Adjust this for more/less padding from edges
    var content: DoubleButtonPopUpContent? = nil
    
    var action: (String) -> Void

    init(isPresented: Binding<Bool>, content: DoubleButtonPopUpContent,  action: @escaping (String) -> Void) {
        self._isPresented = isPresented
        self.content = content
        self.action = action
    }

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
            }
            if isPresented {
                VStack {
                    VStack(alignment: .center, spacing: 20) {
                        Image(content?.imageName ?? "")
                        Text(content?.headerTitle ?? "")
                            .foregroundColor(.black)
                            .font(.custom("Roboto-Medium", fixedSize: 14))
                        Text(content?.description ?? "")
                            .foregroundColor(.black)
                            .font(.custom("OpenSans-Regular", fixedSize: 14))
                            .multilineTextAlignment(.center)
                        if let desc2 = content?.description2 {
                            Text(desc2)
                                .foregroundColor(.black)
                                .font(.custom("OpenSans-Regular", fixedSize: 14))
                                .multilineTextAlignment(.center)
                        }
                        HStack(spacing: 16) {
                            
                            Button(action: {
                                closePopup()
                            }) {
                                Text("Cancel")
                                    .font(.custom("Roboto-Medium", fixedSize: 16))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        ZStack {
                                            // Glass background
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(.ultraThinMaterial)
                                            
                                            // Light border (glass edge)
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                            Color.white.opacity(0.6),
                                                            Color.white.opacity(0.1)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1
                                                )
                                        }
                                    )
                                    .overlay(
                                        // Optional glow effect
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                            .blur(radius: 2)
                                    )
                            }
                            
                            Button(action: {
                                closePopup("1")
                            }) {
                                Text("Ok")
                                    .font(.custom("Roboto-Medium", fixedSize: 16))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        ZStack {
                                            // Glass background
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(.ultraThinMaterial)
                                            
                                            // Light border (glass edge)
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                            Color.white.opacity(0.6),
                                                            Color.white.opacity(0.1)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1
                                                )
                                        }
                                    )
                                    .overlay(
                                        // Optional glow effect
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                            .blur(radius: 2)
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(width: deviceType == .phone ? UIScreen.main.bounds.width - (horizontalPadding * 2) : 408) // Dynamic width
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5)
                .offset(x: offsetX)
                .onAppear {
                    // Reset offsetX so animation works properly
                    offsetX = -UIScreen.main.bounds.width
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        offsetX = 0 // Slide in from left
                    }
                }
            }
        }
    }

    /// **Call this function to close the popup with a slide-out animation to the right**
    func closePopup(_ okorcancel: String = "0") {
        withAnimation(.easeInOut(duration: 0.3)) {
            offsetX = UIScreen.main.bounds.width // Slide out to the right
        }

        // Delay hiding the popup until the animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isPresented = false
            action(okorcancel)
        }
    }
    
    struct LiquidGlassButton: View {
        var title: String
        var action: () -> Void
        var body: some View {
            Button(action: action) {
                HStack(spacing: 12) {
                    // 🌊 Read More Text with Liquid Effort (Gradient & Shadow)
                    Text(title)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.black)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .white,            // Top shine
                                    .white.opacity(0.8)// Bottom body
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .white.opacity(0.5), radius: 2, x: 0, y: 0)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                }
                .padding(.horizontal, 20)
                .frame(height: 50)
                .background(
                    ZStack {
                        // 💎 Base Glass Layer
                        Capsule()
                            .fill(.ultraThinMaterial)
                        
                        // 💡 Liquid Specular Highlight (The "Glass Edge")
                        Capsule()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.6),
                                        .clear,
                                        .white.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    }
                )
                .clipShape(Capsule())
                // 🌚 Subtle shadow to lift it off the card
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                .frame(width: .infinity, height: 50)
            }
            .buttonStyle(PlainButtonStyle()) // Prevents default grey highlighting
        }
    }
}

#Preview {
    DoubleButtonPopUPViewPage(
        isPresented: .constant(true),
        content: DoubleButtonPopUpContent(
            imageName: "alert",
            headerTitle: "Confirm Action!",
            description: "Are you sure you want logout?",
            buttonCancel: "Cancel",
            buttonOk: "Ok"
        )
    ) { flag in
        print(flag)
    }
}
