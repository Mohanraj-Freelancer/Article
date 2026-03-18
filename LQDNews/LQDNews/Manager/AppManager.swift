//
//  AppManager.swift
//  LQDNews
//
//  Created by Mohanraj on 16/03/26.
//

import Reachability
import Cache
import Combine


final class AppManager: ObservableObject {
    
    static let shared = AppManager()
    
    @Published var isOffline: Bool = false
    
    private let reachability: Reachability
    
    // Cache
    let storage: Storage<String, [Article]>?
    
    private init() {
        
        // ✅ Strong initialization (no optional)
        self.reachability = try! Reachability()
        
        self.storage = try? Storage<String, [Article]>(
            diskConfig: DiskConfig(name: "ArticleCache"),
            memoryConfig: MemoryConfig(),
            transformer: TransformerFactory.forCodable(ofType: [Article].self)
        )
        
        setupReachability()
    }
    
    private func setupReachability() {
        
        reachability.whenUnreachable = { [weak self] _ in
            DispatchQueue.main.async {
                print("📴 Offline")
                self?.isOffline = true
            }
        }
        
        reachability.whenReachable = { [weak self] _ in
            DispatchQueue.main.async {
                print("🌐 Online")
                self?.isOffline = false
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("❌ Reachability failed:", error)
        }
    }
}
