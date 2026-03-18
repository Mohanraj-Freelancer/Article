//
//  ArticleListView.swift
//  LQDNews
//
//  Created by Mohanraj on 16/03/26.
//
import SwiftUI
import Cache
import Combine
import Kingfisher
import Loaf

struct ArticleListView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @StateObject var viewModel = ArticleViewModel()
    @StateObject var network = AppManager.shared
    @State private var showPopup = false
    @State private var selectedArticle: Article?
    private var columns: [GridItem] {
        viewModel.isGridView
        ? [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
        : [GridItem(.flexible(), spacing: 16)]
    }
    
    var filteredArticles: [Article] {
        viewModel.searchText.isEmpty
        ? viewModel.articles.filter {
            ($0.title ?? "") != "[Removed]" &&
            !($0.title ?? "").isEmpty
        }
        : viewModel.articles.filter {
            $0.title?.localizedCaseInsensitiveContains(viewModel.searchText) ?? false
        }
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                // 🌊 Background
                Color.blue.opacity(0.1).ignoresSafeArea()
                Rectangle().fill(.ultraThinMaterial).ignoresSafeArea()
                
                // 🔥 STATE-BASED UI
                contentView
            }
            // 🌐 Auto reload when back online
            .onReceive(network.$isOffline) { isOffline in
                if !isOffline {
                    viewModel.loadArticles()
                }
            }
            .overlay(confirmationPopUp)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 1. Top Left Custom Liquid Title
                if !viewModel.isSearching {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Articles")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.black)
                        // 🌊 The Liquid Effect: Gradient Text
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .white,           // Top highlight
                                        .white.opacity(0.7),
                                        .white.opacity(0.5) // Bottom depth
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        // 💎 The Glass Effect: Soft Glow & Shadow
                            .shadow(color: .white.opacity(0.5), radius: 2, x: 0, y: 0)
                            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                            .frame(width: 130, alignment: .center)
                    }
                }
                // --- CENTER: SEARCH BAR ---
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.isSearching {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Search...", text: $viewModel.searchText)
                                .textFieldStyle(.plain)
                                .onChange(of: viewModel.searchText) { oldValue, newValue in
                                    if !viewModel.isSearching {
                                        viewModel.searchText = ""
                                    }
                                }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 0.5))
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                        .frame(width: 220, alignment: .leading)
                    }
                }
                // --- TRAILING: BUTTONS ---
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Grid Toggle (Only show if not searching to save space)
                    Button {
                        withAnimation(.spring()) {
                            viewModel.isGridView.toggle()
                        }
                    } label: {
                        Image(systemName: viewModel.isGridView ? "list.bullet" : "square.grid.2x2")
                    }
                    
                    // Search Toggle
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            // 1. Clear text FIRST
                            
                            viewModel.searchText = ""
                            
                            viewModel.isSearching.toggle()
                        }
                    } label: {
                        Image(systemName: viewModel.isSearching ? "xmark.circle.fill" : "magnifyingglass")
                            .font(.system(size: 18, weight: .bold))
                    }
                    if !viewModel.isSearching {
                        // Logout
                        Button {
                            showPopup = true
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            // Ensure the bar stays transparent for the "Liquid Glass" look
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
    @ViewBuilder
    var confirmationPopUp: some View {
        DoubleButtonPopUPViewPage(
            isPresented: $showPopup,
            content: DoubleButtonPopUpContent(
                imageName: "alert",
                headerTitle: "Confirm Action!",
                description: "Are sure you want to logout?",
                buttonCancel: "Cancel",
                buttonOk: "Yes"
            )
        ) { flag in
            if flag == "1" {
                loginViewModel.logout()
            }
        }
    }
}
extension ArticleListView {
    
    @ViewBuilder
    var contentView: some View {
        
        switch viewModel.state {
            
        case .loading:
            ZStack {
                FTActivityIndicator(isAnimating: .constant(true))
                    .frame(width: 60, height: 60)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .success:
            articleListView
            
        case .empty:
            Text("No Articles Found")
                .font(.title3)
                .foregroundColor(.black)
            
        case .offline:
            OfflinePageView {
                handleRetry()
            }
            
        case .error(let message):
            VStack {
                Text(message)
                Button("Retry") {
                    handleRetry()
                }
            }
            
        default:
            EmptyView()
        }
    }
}
extension ArticleListView {
    
    var articleListView: some View {
        
        VStack(spacing: 0) {
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    
                    ForEach(filteredArticles, id: \.identifier) { article in
                        ArticleCard(article: article, isGrid: viewModel.isGridView) {
                            selectedArticle = article
                        }
                        .onTapGesture {
                            selectedArticle = article
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                viewModel.loadArticles()
            }
        }
        .navigationDestination(item: $selectedArticle) { article in
            ArticleDetailView(article: article)
        }
    }
}

extension ArticleListView {
    
    func handleRetry() {
        
        // 🚫 Prevent multiple taps
        if case .loading = viewModel.state { return }
        
        // ❌ Still offline
        if network.isOffline {
            ToastManager.show("No Internet Connection", state: .warning)
            return
        }
        
        // 🔄 Retry
        ToastManager.show("Retrying...", state: .info)
        viewModel.retry()
    }
}

struct ArticleCard: View {
    
    let article: Article
    let isGrid: Bool // Added this to fix the scope error
    let action: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            if let urlString = article.urlToImage,
               let url = URL(string: urlString),
               !urlString.isEmpty {
                
                KFImage(url)
                    .resizable()
                    .placeholder {
                        Image("news_placeholder")
                            .resizable()
                            .scaledToFill()
                    }
                    .onFailureImage(Image(contentsOfFile: "news_placeholder"))
                    .aspectRatio(16/9, contentMode: .fill)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Image("news_placeholder")
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fill)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            Text(article.title ?? "")
                .font(.headline)
                .lineLimit(2)
                .frame(height: 60, alignment: .top) // ✅ consistent height
            
            if !isGrid {
                HStack {
                    HStack(spacing: 8) {
                        // 💎 Liquid Glass Calendar Icon
                        Image(systemName: "calendar")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue.opacity(0.8), .blue.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .padding(6)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial) // Glassy circle behind the icon
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            )
                            .overlay(
                                Circle()
                                    .stroke(.white.opacity(0.5), lineWidth: 0.5) // Shine on the edge
                            )
                        
                        Text(article.formattedDate)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    LiquidGlassButton {
                        action()
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.thinMaterial) // Slightly thicker than the background
                .shadow(color: .black.opacity(0.05), radius: 10)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.2), lineWidth: 1) // The "glint" on the glass edge
        )
        .shadow(color: .black.opacity(0.08), radius: 10, y: 6)
    }
    // A dedicated view for the reusable "Liquid Glass" button
    struct LiquidGlassButton: View {
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 12) {
                    // 🌊 Read More Text with Liquid Effort (Gradient & Shadow)
                    Text("Read More")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
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
                    
//                    Spacer(minLength: 10)
                    
                    // 🏹 Glowing Icon Circle
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.9))
                            .frame(width: 32, height: 32)
                            .shadow(color: .white.opacity(0.4), radius: 4, x: 0, y: 0)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .black))
                            .foregroundColor(Color.blue.opacity(0.7))
                    }
                }
                .padding(.horizontal, 20)
                .frame(height: 52)
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
            }
            .buttonStyle(PlainButtonStyle()) // Prevents default grey highlighting
        }
    }
}
