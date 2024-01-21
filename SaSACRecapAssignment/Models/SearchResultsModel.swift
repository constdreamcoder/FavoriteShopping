//
//  ShoppingResultModel.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/20/24.
//

import Foundation

struct SearchResultsModel: Codable {
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
}

struct Item: Codable {
    let productId: String
    let mallName: String
    let title: String
    let image: String
    let lprice: String
}
