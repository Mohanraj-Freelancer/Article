//
//  ArticleDetailView.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//


import SwiftUI
import Kingfisher

// 🔹 Offset tracker
struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ArticleDetailView: View {
    let article: Article
    let collapseRange: CGFloat = 120
    let titleFadeRange: CGFloat = 80
    @Environment(\.dismiss) var dismiss
    
    @State private var offset: CGFloat = 0 // 🔹 NEW
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // 🔥 Animated Header Background
            Color(red: 0.12, green: 0.2, blue: 0.24)
                .ignoresSafeArea()
                .frame(height: max(200, UIScreen.main.bounds.height * 0.35 + offset)) // 👈 collapse/expand
            
            VStack(spacing: 0) {
                
                // 🔹 NAVBAR
                HStack(alignment: .center) {
                    
                    Button { dismiss() } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3.bold())
                            .padding(12)
                            .background(.white.opacity(0.1))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Article")
                        .font(.title)
                        .foregroundColor(.white)
                        .animation(.easeInOut, value: offset)
                        .padding(.trailing, 12)
                    
                    Spacer()
                    
                    Image(systemName: "heart.badge.plus")
                        .font(.title2)
                        .padding(12)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ScrollView(showsIndicators: false) {
                    
                    // 🔹 Track scroll
                    GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: OffsetPreferenceKey.self,
                                value: geo.frame(in: .global).minY
                            )
                    }
                    .frame(height: 0)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        // 🔹 HEADER TEXT
                        VStack(alignment: .leading, spacing: 8) {
                            Text(article.title ?? "Title")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            HStack {
                                Image(systemName: "clock")
                                Text(timeAgo(from: article.formattedDate))
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        
                        // 🔹 IMAGE
                        if let urlString = article.urlToImage, !urlString.isEmpty {
                            KFImage(URL(string: urlString))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width * 0.95 ,height: UIScreen.main.bounds.width * 0.55)
                                .offset(y: offset > 0 ? -min(offset * 0.3, 40) : 0) // 👈 parallax
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                                .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                        }
                        
                        // 🔹 CONTENT
                        VStack(alignment: .leading, spacing: 20) {
                            Text(article.content ?? article.description ?? "No content.")
                                .font(.body)
                                .lineSpacing(6)
                                .foregroundColor(.gray)
                                .padding(.top, 30)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                    }
                }
                .onPreferenceChange(OffsetPreferenceKey.self) { value in
                    offset = value
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.white.ignoresSafeArea())
    }
    
    func timeAgo(from dateString: String?) -> String {
        guard let dateString = dateString else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d-MMM,yyyy"
        
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .abbreviated
        
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
}


// Header


// Image


// Padding


// Offset

