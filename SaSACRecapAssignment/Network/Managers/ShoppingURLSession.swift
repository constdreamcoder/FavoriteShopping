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
        display: Int = 30,
        completionHandler: @escaping (SearchResultsModel?, ShoppingURLSesssionError?) -> Void
    ) {
        if let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            let baseURL = "https://openapi.naver.com/v1/search/shop.json"
            
            var urlComponents = URLComponents(string: baseURL)
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "query", value: "\(query)"),
                URLQueryItem(name: "display", value: "\(display)"),
                URLQueryItem(name: "sort", value: "\(sortingStandard.rawValue)"),
                URLQueryItem(name: "start", value: "\(start)")
            ]
            
            guard let url = urlComponents?.url else { return }
            var urlRequest = URLRequest(url: url)
            
            urlRequest.allHTTPHeaderFields = [
                "X-Naver-Client-Id": APIKeys.clientID,
                "X-Naver-Client-Secret": APIKeys.clientSecret
            ]
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                DispatchQueue.main.async {
                    
                    
                    guard error == nil else {
                        print("네트워크 오류")
                        completionHandler(nil, .failedRequest)
                        return
                    }
                    
                    guard let data = data else {
                        print("네트워크 통신은 성공했지만, data를 수신받지 못함")
                        completionHandler(nil, .noData)
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else {
                        print("네트워크 통신은 성공했지만, response를 수신받지 못함")
                        completionHandler(nil, .invalidResponse)
                        return
                    }
                    
                    guard (200..<300).contains(response.statusCode) else {
                        print("네트워크 통신은 성공했지만, 올바른 값이 오지 않음")
                        completionHandler(nil, .failedRequest)
                        return
                    }
                    
                    do {
                        let decodedResults = try JSONDecoder().decode(SearchResultsModel.self, from: data)
                        completionHandler(decodedResults, nil)
                    } catch {
                        completionHandler(nil, .invalidData)
                        print(error)
                    }
                }
            }.resume()
            
        }
    }
}
