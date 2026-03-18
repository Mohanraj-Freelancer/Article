//
//  ArticleModel.swift
//  LQDNews
//
//  Created by Mohanraj on 16/03/26.
//

import Foundation

// Ensure Article and ArticleResponse are outside of any class
// MARK: - API Response
struct ArticleResponse: Codable {
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable, Identifiable, Hashable {
    var id: String? // For SwiftUI list
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    var identifier: String {
        return id ?? url ?? UUID().uuidString
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    // 2. Tell Swift how to hash the article
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    // MARK: - Formatted Date
    var formattedDate: String {
        guard let dateStr = publishedAt else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = formatter.date(from: dateStr) {
            formatter.dateFormat = "dd-MMM,yyyy"
            return formatter.string(from: date)
        }
        
        return ""
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}

// Provider Protocols [cite: 56]
protocol ArticleProviderProtocol: Sendable {
    func fetchArticles(completion: @escaping @Sendable (Result<[Article], Error>) -> Void)
}
