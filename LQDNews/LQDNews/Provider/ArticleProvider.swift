//
//  ArticleProvider.swift
//  LQDNews
//
//  Created by Mohanraj on 16/03/26.
//

import Alamofire
import XCGLogger

final class ArticleProvider: ArticleProviderProtocol {
    private let log = XCGLogger.default
    private let apiURL = "https://mocki.io/v1/50422b19-547f-41c0-b623-e82d886ad264"
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        // Fetch raw data instead of using responseDecodable
        AF.request(apiURL).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    // Manual decoding bypasses the actor-isolation error
                    // on the responseDecodable parameter
                    let decoder = JSONDecoder()
                    
                    // API date format is usually ISO8601. If it's different,
                    // use a custom DateFormatter here.
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    
                    // ✅ Correct decoding
                    let decodedResponse = try decoder.decode(ArticleResponse.self, from: data)
                    self.log.info("Successfully decoded \(decodedResponse.articles) articles.")
                    DispatchQueue.main.async {
                        completion(.success(decodedResponse.articles))
                    }
                } catch {
                    self.log.error("Decoding error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                self.log.error("Network error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
