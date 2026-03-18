//
//  ArticleViewModel.swift
//  LQDNews
//
//  Created by Mohanraj on 16/03/26.
//

import SwiftUI
import Cache
import Combine

// MARK: - View State
enum ArticleState {
    case idle
    case loading
    case success
    case empty
    case offline
    case error(String)
}

class ArticleViewModel: ObservableObject {
    
    @Published var state: ArticleState = .idle
    @Published var articles: [Article] = []
    @Published var isGridView: Bool = false
    @Published var isSearching = false
    @Published var searchText = ""
    
    private let provider: ArticleProviderProtocol
    
    init(provider: ArticleProviderProtocol = ArticleProvider()) {
        self.provider = provider
        self.loadArticles()
    }
    
    // MARK: - Load Articles
    func loadArticles() {
        
        // 🚫 If offline → load cache
        if AppManager.shared.isOffline {
            loadFromCache()
            return
        }
        
        state = .loading
        
        provider.fetchArticles { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let articles):
                    self.articles = articles
                    
                    // 💾 Save to cache
                    try? AppManager.shared.storage?.setObject(articles, forKey: "saved_articles")
                    
                    self.state = articles.isEmpty ? .empty : .success
                    
                case .failure:
                    self.loadFromCache()
                }
            }
        }
    }
    
    // MARK: - Cache Handling
    private func loadFromCache() {
        
        if let cached = try? AppManager.shared.storage?.object(forKey: "saved_articles") {
            self.articles = cached
            self.state = .success
        } else {
            self.state = .offline
        }
    }
    
    // MARK: - Retry
    func retry() {
        
        if AppManager.shared.isOffline {
            state = .offline
            return
        }
        
        loadArticles()
    }
}
