//
//  ShoppingManager.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/20/24.
//

import Foundation
import Alamofire

class ShoppingManager {
    static let shared = ShoppingManager()
    
    private init() {}
    
    func fetchShoppingResults(
        keyword: String,
        sortingStandard: SortingStandard = .byAccuracy,
        start: Int = 1,
        display: Int = 30,
        completionHandler: @escaping (SearchResultsModel) -> Void
    ) {        
        if let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let urlString = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=\(display)&sort=\(sortingStandard.rawValue)&start=\(start)"
            
            let headers: HTTPHeaders = [
                "X-Naver-Client-Id": APIKeys.clientID,
                "X-Naver-Client-Secret": APIKeys.clientSecret
            ]
            
            AF.request(urlString, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: SearchResultsModel.self) { response in
                    switch response.result {
                    case .success(let success):
                        dump(success)
                        completionHandler(success)
                    case .failure(let failure):
                        print(failure)
                    }
                }
        }
        
        
    }
}
