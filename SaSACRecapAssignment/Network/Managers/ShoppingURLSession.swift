//
//  ShoppingURLSession.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 2/5/24.
//

import Foundation
import Alamofire

final class ShoppingURLSession {
    static let shared = ShoppingURLSession()
    
    private init() {}
    
    func fetchShoppingResults(
        keyword: String,
        sortingStandard: SortingStandard = .byAccuracy,
        start: Int = 1,
        display: Int = 30
    ) async throws -> SearchResultsModel {
        if let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            let baseURL = "https://openapi.naver.com/v1/search/shop.json"
            
            var urlComponents = URLComponents(string: baseURL)
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "query", value: "\(query)"),
                URLQueryItem(name: "display", value: "\(display)"),
                URLQueryItem(name: "sort", value: "\(sortingStandard.rawValue)"),
                URLQueryItem(name: "start", value: "\(start)")
            ]
            
            guard let url = urlComponents?.url else {
                throw ShoppingURLSesssionError.invalidURL
            }
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.allHTTPHeaderFields = [
                "X-Naver-Client-Id": APIKeys.clientID,
                "X-Naver-Client-Secret": APIKeys.clientSecret
            ]
           
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let response = response as? HTTPURLResponse else {
                throw ShoppingURLSesssionError.invalidResponse
            }
        
            guard (200..<300).contains(response.statusCode) else {
                throw ShoppingURLSesssionError.failedRequest
            }
            
            do {
                let decodedResults = try JSONDecoder().decode(SearchResultsModel.self, from: data)
                return decodedResults
            } catch {
                throw ShoppingURLSesssionError.invalidData
            }
        }
        throw ShoppingURLSesssionError.unknownError
    }
}
